import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/provider/preference_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/price_range_input.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/radio_buttons.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/stars_radio_button.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/year_range_input.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/sorting_type.dart';

class PreferencesBottomSheet extends ConsumerStatefulWidget{
  final Preference initialPreference;

  const PreferencesBottomSheet({required this.initialPreference, });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _PreferencesState();
  }
}
class _PreferencesState extends ConsumerState<PreferencesBottomSheet>{
  ResponsiveValue responsiveValue = ResponsiveValue();
  String _selectedSortOption = '';
  String _maturityRating = '';
  String _saleabilityOption = '';
  String _minAverageRatings = '';
  String _availability = '';
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController minYController = TextEditingController();
  TextEditingController maxYController = TextEditingController();

  String onSubmit(context){
    if(minController.text.isNotEmpty && maxController.text.isNotEmpty){
      if(int.parse(minController.text) > int.parse(maxController.text)){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, harga maksimal tidak boleh lebih kecil daripada harga minimal'));
        return 'ERROR';
      }
    }
    if(minYController.text.isNotEmpty){
      if(double.parse(minYController.text) < 1978){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, tahun minimal tidak boleh lebih kecil daripada 1978'));
        return 'ERROR';
      }
      if(double.parse(minYController.text) > 2023){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, tahun minimal tidak boleh lebih besar daripada 2023'));
        return 'ERROR';
      }
    }
    if(maxYController.text.isNotEmpty){
      print('hello');
      print(double.parse(maxYController.text));
      if(double.parse(maxYController.text) > 2023){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, tahun maksimal tidak boleh lebih besar daripada 2023'));
        return 'ERROR';
      }
      if(double.parse(maxYController.text) < 1978){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, tahun maksimal tidak boleh lebih kecil daripada 1978'));
        return 'ERROR';
      }
    }
    if(minYController.text.isNotEmpty && maxYController.text.isNotEmpty){
      if(int.parse(minYController.text) > int.parse(maxYController.text)){
        showTopSnackBar(Overlay.of(context), CustomSnackBar.error
          (message: 'Maaf, tahun maksimal tidak boleh lebih kecil daripada tahun minimal'));
        return 'ERROR';
      }
    }
    if(_saleabilityOption.toLowerCase() == 'available for free' &&
        (minController.text.isNotEmpty || maxController.text.isNotEmpty)){
      showTopSnackBar(Overlay.of(context), CustomSnackBar.error
        (message: 'Maaf, range harga tidak dapat diatur untuk buku yang gratis'));
      return 'ERROR';
    }
    ref.read(preferenceProvider.notifier).updateStateWith(
        minYear: minYController.text,
        maxYear: maxYController.text,
        minAvgRating: _minAverageRatings,
        saleabilityOption: _saleabilityOption,
        sortingType: convertToSortingType(_selectedSortOption),
        maxPrice: maxController.text,
        minPrice: minController.text,
        maturityRating: _maturityRating,
        availability: _availability
    );
    return 'SUCCESS';


  }

  void defaultValues(){
    Preference defaultPreference = Preference(
        sortingType: SortingType.terbaru,
        isWelcomeClosed: false,
        maturityRating: 'All',
        saleabilityOption: 'All',
        minAvgRating: 'Default',
        minPrice: '',
        maxPrice: '',
        availability: 'All',
        minYear: '',
        maxYear: ''
    );

    _selectedSortOption = defaultPreference.sortingType.value;
    _maturityRating = defaultPreference.maturityRating;
    _saleabilityOption = defaultPreference.saleabilityOption;
    _minAverageRatings = defaultPreference.minAvgRating!;
    _availability = defaultPreference.availability;
    minController.text = defaultPreference.minPrice?? '';
    maxController.text = defaultPreference.maxPrice?? '';
    minYController.text = defaultPreference.minYear ?? '';
    maxYController.text = defaultPreference.maxYear ?? '';

  }

  void initValues(){
    _selectedSortOption = widget.initialPreference.sortingType.value;
    _maturityRating = widget.initialPreference.maturityRating;
    _saleabilityOption = widget.initialPreference.saleabilityOption;
    _minAverageRatings = widget.initialPreference.minAvgRating!;
    _availability = widget.initialPreference.availability;
    minController.text = widget.initialPreference.minPrice?? '';
    maxController.text = widget.initialPreference.maxPrice?? '';
    minYController.text = widget.initialPreference.minYear ?? '';
    maxYController.text = widget.initialPreference.maxYear ?? '';
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    maxYController.dispose();
    minYController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initValues();

  }
  @override
  Widget build(BuildContext context) {


    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Container(

      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container(
            constraints: BoxConstraints(
                maxWidth: 768
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Book Preferences',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: responsiveValue.titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(onPressed: (){
                            setState(() {
                              defaultValues();
                            });
                          }, child: Text('Reset to Default', maxLines: 2, style: TextStyle(fontSize: responsiveValue.contentFontSize),))
                        ],
                      ),
                      SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sort By', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Wrap(

                            children: [

                              RadioButtons(options: SortingType.values.map((e) => e.value).toList(), selectedOption: _selectedSortOption,
                                  onChanged: (a){
                                    setState(() {
                                      _selectedSortOption = a;
                                    });
                                  }),
                              SizedBox(height: 8,),
                            ],
                          )
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Maturity Rating', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Wrap(

                            children: [

                              RadioButtons(options: const ['All', 'Not Mature' , 'Mature'], selectedOption: _maturityRating,
                                  onChanged: (a){
                                    setState(() {
                                      _maturityRating = a;
                                    });
                                  }),
                              SizedBox(height: 8,),
                            ],
                          ),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saleability Option', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Wrap(
                            children: [

                              RadioButtons(options: ['All', 'Available for Free', 'Paid Purchase'], selectedOption:_saleabilityOption,
                                  onChanged: (a){
                                    setState(() {
                                      _saleabilityOption = a;
                                    });
                                  }),
                              SizedBox(height: 8,),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Average Ratings', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 8,),
                          Wrap(
                            children: [
                              StarsRadioButtons(averageRatingOptions: ['Default', '4', '3', '2', '1'], currentSelected: _minAverageRatings, callBack: (value){
                                setState(() {
                                  _minAverageRatings = value;
                                });
                              }),
                              SizedBox(height: 8,),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Availability', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Wrap(

                            children: [

                              RadioButtons(options: ['All', 'PDF', 'EPUB'], selectedOption: _availability,
                                  onChanged: (a){
                                    setState(() {
                                      _availability = a;
                                    });
                                  }),
                              SizedBox(height: 8,),
                            ],
                          )
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Range', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          PriceRangeInput(minPriceController: minController, maxPriceController: maxController, onPriceChanged: (_,__){})
                        ],),
                      SizedBox(height: 8,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Year Range', textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: responsiveValue.contentFontSize,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          YearRangeInput(minYearController: minYController, maxYearController: maxYController, onYearChanged: (_,__){})
                        ],),

                    ],
                  ),
                )),
                SizedBox(height: 8,),
                // Tambahkan widget lain untuk pengaturan filter di sini
                Container(

                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          final res = onSubmit(context);
                          if(res == 'ERROR'){
                            setState(() {
                              initValues();
                            });
                          }
                          else{
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16)
                        ),
                        child: Text('Apply Filter', style: TextStyle(fontSize: responsiveValue.titleFontSize),),
                      )),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
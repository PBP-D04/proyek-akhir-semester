import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/models/sorting_type.dart';
import 'package:proyek_akhir_semester/Homepage/provider/categories_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/preference_provider.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/Homepage/util/provider_helper.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/categories_list.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/preferences_bottom_sheet.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/radio_buttons.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/welcome_widget.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_card.dart';
import '../../models/responsive.dart';
import '../../util/responsive_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SearchResultPage extends ConsumerStatefulWidget{
  final String searchText;
  const SearchResultPage({super.key, required this.searchText});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _SearchResultPageState();
  }
}

class _SearchResultPageState extends ConsumerState<SearchResultPage>{
  ResponsiveValue responsiveValue = ResponsiveValue();
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.text = widget.searchText;
  }
  void _showFilterBottomSheet(BuildContext context) {
    final preference = ref.watch(preferenceProvider);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PreferencesBottomSheet(initialPreference: preference,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesStatus = ref.watch(categoriesProvider);
    final preference = ref.watch(preferenceProvider);
    var books = ref.watch(booksProvider);
    List<Book>  bookList = books.entries
        .map((entry) => entry.value).toList();
    // TODO: implement build
    responsiveValue.setResponsive(context);
    bookList = filterBooks(bookList, categoriesStatus.currentSelectedCategory, preference);
    bookList = sorting(preference.sortingType, bookList);
    bookList = bookList.where((book) => book.title.toLowerCase().contains(widget.searchText.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_rounded, color: Colors.black,)),
          SizedBox(width: 8,),
          Expanded(child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(

                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(getScreenSize(context) != ScreenSize.small)Spacer(),
                  Flexible(
                    flex: 2,
                      child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: _searchController,
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return SearchPage(initialSearchText: widget.searchText,);
                        }));
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari di Bookphoria',
                        // Add a clear button to the search bar
                        // Add a search icon or button to the search bar
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Perform the search here
                            //sengaja kosong
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  )),
                  if(getScreenSize(context) != ScreenSize.small)Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_outline_rounded, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu_rounded, color: Colors.black),
                  ),
                ],
              ))
            ],
          )),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true, // Tetap melekat di bagian atas layar
            floating: true, // Muncul atau menghilang saat digulir
            snap: true,
            backgroundColor: Colors.white,
            actions: [
              Expanded(child: Row(
                children: [
                  CategoriesList(categories: categoriesStatus.categories,
                      setScrollCategories: (value){
                        OffsetSingleton.instance.setOffset(value);
                      },
                      onPressed: (selectedValue){
                        ref.read(categoriesProvider.notifier).state =
                            CategoriesState(currentSelectedCategory: selectedValue,  categories: categoriesStatus.categories);
                      },
                      currentSelectedCategory: categoriesStatus.currentSelectedCategory)

                ],)),
              SizedBox(width: 12,),
              Container(
                padding: EdgeInsets.only(top: 13, bottom: 13, right: 8),

                constraints: BoxConstraints(
                    maxHeight: 34,
                    minWidth:getScreenSize(context) == ScreenSize.small ? 100 : 130
                ), child: ElevatedButton(
                  onPressed: (){
                    _showFilterBottomSheet(context);
                  }, style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent.shade700),child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.filter_list, color: Colors.white), // Ganti dengan ikon yang diinginkan
                  SizedBox(width: 8), // Jarak antara ikon dan teks
                  Text(
                    'Filter',
                    style: TextStyle(fontSize: responsiveValue.contentFontSize),
                  ),],
              )),)
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: getScreenSize(context) != ScreenSize.small? 18 : 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${categoriesStatus.currentSelectedCategory}(${bookList.length})',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsiveValue.extraTitleFontSize,
                            fontWeight: FontWeight.bold

                        ),),),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0), // Bentuk rounded rectangle
                          color: Colors.indigoAccent.shade700, // Warna latar belakang dropdown header
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<SortingType>(
                              value: preference.sortingType,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Icon dropdown
                              iconSize: 24.0,
                              elevation: 16,
                              dropdownColor: Colors.indigoAccent.shade700,
                              style: TextStyle(color: Colors.white, fontSize: responsiveValue.contentFontSize), // Warna teks dropdown header
                              onChanged: (SortingType? newValue) {
                                ref.read(preferenceProvider.notifier).updateStateWith(sortingType: newValue);
                              },
                              items: SortingType.values.map((SortingType sortingType) {
                                return DropdownMenuItem<SortingType>(
                                  value: sortingType,
                                  child: Text(sortingType.value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 8,),
                  bookList.length != 0 ?GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: MediaQuery.of(context).size.width > 450 ||
                          MediaQuery.of(context).size.width < 285? 3/6 : 3/7 ,
                    ),
                    itemCount: bookList.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Tambahkan item-item Anda di sini
                      return BookCard(book: bookList.elementAt(index));
                    },
                  ) : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.32,
                      child: Center(
                        child:  Text('Tidak ada buku yang tersedia', style: TextStyle(
                            fontSize: responsiveValue.subtitleFontSize
                        ),),
                      )
                  ),
                ],
              ),
            ),
          )
        ],
      ) ,
    );
  }
}
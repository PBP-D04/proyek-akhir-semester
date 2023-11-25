import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/util/provider_helper.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class CategoriesList extends StatefulWidget{
  final List<String> categories;
  final Function(String) onPressed;
  final String currentSelectedCategory;
  final Function(double) setScrollCategories;

  CategoriesList({required this.categories, required this.setScrollCategories ,required this.onPressed, required this.currentSelectedCategory});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CategoriesListState();
  }
}

class _CategoriesListState extends State<CategoriesList> {

  final ResponsiveValue responsiveValue = ResponsiveValue();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: OffsetSingleton.instance.offset );
    _scrollController.addListener(_scrollListener);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _scrollListener() {
     widget.setScrollCategories(_scrollController.offset);
  }
  @override
  Widget build(BuildContext context) {
    responsiveValue.setResponsive(context);
    return Expanded(child: SizedBox(
      height: 30,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,

        itemCount: widget.categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.onPressed(widget.categories[index]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.currentSelectedCategory == widget.categories[index] ? Colors.blue : Colors.grey.shade200, // Ubah warna sesuai kategori yang dipilih

              ),
              child: Text(widget.categories[index], style: TextStyle(fontSize: responsiveValue.contentFontSize,color: widget.currentSelectedCategory == widget.categories[index] ? Colors.white : Colors.black ),),
            ),
          );
        },
      ),
    ));
  }
}
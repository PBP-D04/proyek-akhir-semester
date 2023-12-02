
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/screens/wishlist_book_page.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

import '../Homepage/screens/search_page.dart';
import '../models/responsive.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  final ResponsiveValue responsiveValue = ResponsiveValue();
  final GlobalKey<ScaffoldState> scaffoldKey;
  String? searchText;
  String? title;
  MyAppBar({ required this.scaffoldKey, this.searchText, this.title});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        SizedBox(width: 8,),
        Expanded(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${title??'Bookphoria'}', style: TextStyle(fontWeight:FontWeight.bold, fontSize:  responsiveValue.extraTitleFontSize,color: Colors.indigoAccent.shade700),),
            Flexible(child: Container(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: getScreenSize(context) == ScreenSize.small ? 150 :
                  getScreenSize(context) == ScreenSize.medium? 250 : 350 ) ,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          print('object---------------');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return SearchPage();
                          }));
                        },
                        icon: Icon(Icons.search_rounded, color: Colors.black),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return WishlistPage();
                          }));
                        },
                        icon: Icon(Icons.favorite_outline_rounded, color: Colors.black),
                      ),
                      IconButton(
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Icon(Icons.menu_rounded, color: Colors.black),
                      ),
                    ],
                  ),
                )
            ),)
          ],
        )),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
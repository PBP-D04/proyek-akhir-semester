import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_form.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class DaftarReview extends ConsumerStatefulWidget {
  int bookId;
  DaftarReview({super.key, required this.bookId});

  @override
  ConsumerState<DaftarReview> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<DaftarReview> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final responsiveValue = ResponsiveValue();
  @override
  Widget build(BuildContext context) {
    List<Review> reviewList= ref.watch(reviewListProvider);
    final selectedReviewList = reviewList.where((review) => review.bookId==widget.bookId).toList();
    responsiveValue.setResponsive(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 8,),
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bookphoria', style: TextStyle(fontWeight:FontWeight.bold, fontSize:  responsiveValue.extraTitleFontSize,color: Colors.indigoAccent.shade700),),
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
                       onPressed: () {},
                       icon: Icon(Icons.favorite_outline_rounded, color: Colors.black),
                     ),
                     IconButton(
                       onPressed: () {
                         key.currentState?.openDrawer();
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
      ),
    body:Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                           return ReviewFormPage(bookId: widget.bookId,);
                         }));
            }, icon: Icon(Icons.add, color: Colors.black),)
          ],
        )
      ],
    ));
  }
}
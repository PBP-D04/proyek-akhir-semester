import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_form.dart';
import 'package:proyek_akhir_semester/ReviewBook/widgets/reviewbook_widgets.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';

class DaftarReview extends ConsumerStatefulWidget {
  int bookId;
  DaftarReview({super.key, required this.bookId});

  @override
  ConsumerState<DaftarReview> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<DaftarReview> {
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final responsiveValue = ResponsiveValue();
  @override
  Widget build(BuildContext context) {
    Map<int,Review> reviewMap= ref.watch(reviewListProvider);
    print(reviewMap.length);
    final reviewList = reviewMap.entries
        .map((entry) => entry.value)
        .toList().reversed.toList();
    final selectedList = reviewList.where((review) => review.bookId == widget.bookId ).toList();
    print('------------------------------------');
    print(selectedList.length);
    responsiveValue.setResponsive(context);
    return Scaffold(
      appBar: MyAppBar(
        scaffoldKey: key1,
        title: 'Reviews List',
      ),
    body:Padding(
      padding: EdgeInsets.all(12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ReviewFormPage(bookId: widget.bookId);
                }));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Adjust padding for width and height
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tambah Review',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
            ),

          ],
        ),
        Expanded(child: selectedList.isNotEmpty?ListView.builder(itemCount: selectedList.length,itemBuilder: (context, index){
          Review review = selectedList.elementAt(index);
          return ReviewItem(username:review.user.username , reviewId: review.id, bookId: widget.bookId,rating: review.rating,
              reviewText: review.content, profileImage: review.user.profilePicture??'', photo: review.photoUrl, userId: review.user.id,);
        }): Center(
          child: Text('Belum ada review', style: TextStyle(fontSize: responsiveValue.contentFontSize,color: Colors.black),),
        ))
      ],
    )),
    );
  }
}
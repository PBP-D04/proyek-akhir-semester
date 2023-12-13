import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_tile.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_form.dart';
import 'package:proyek_akhir_semester/ReviewBook/widgets/reviewbook_widgets.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';

import '../../Homepage/models/book.dart';

// Mengedit ulasan yang telah dibuat sebelumnya

class DaftarReviewSaya extends ConsumerStatefulWidget {
  int userId;
  DaftarReviewSaya({super.key, required this.userId});

  @override
  ConsumerState<DaftarReviewSaya> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<DaftarReviewSaya> {
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final responsiveValue = ResponsiveValue();
  @override
  Widget build(BuildContext context) {
    Map<int,Review> reviewMap= ref.watch(reviewListProvider);
    Map<int, Book> bookReviews = ref.watch(booksProvider);
    print(reviewMap.length);
    final reviewList = reviewMap.entries
        .map((entry) => entry.value)
        .toList().reversed.toList();
    final selectedList = reviewList.where((review) => review.user.id == widget.userId ).toList();
    print('------------------------------------');
    print(selectedList.length);
    responsiveValue.setResponsive(context);
    return Scaffold(
      key: key1,
      appBar: MyAppBar(
        scaffoldKey: key1,
        title: 'My Reviews List',
      ),
      body:Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(child: selectedList.isNotEmpty?ListView.builder(itemCount: selectedList.length,itemBuilder: (context, index){
                Review review = selectedList.elementAt(index);
                return Column(
                  children: [
                    if(bookReviews.containsKey(review.bookId))BookListTile(book: bookReviews[review.bookId]!),
                    ReviewItem(username:review.user.username , reviewId: review.id, bookId: review.bookId,rating: review.rating,
                      reviewText: review.content, profileImage: review.user.profilePicture??'', bookImage: review.bookImageUrl, userId: review.user.id,)
                  ],
                );
              }): Center(
                child: Text('No reviews available', style: TextStyle(fontSize: responsiveValue.contentFontSize,color: Colors.black),),
              ))
            ],
          )),
    );
  }
}
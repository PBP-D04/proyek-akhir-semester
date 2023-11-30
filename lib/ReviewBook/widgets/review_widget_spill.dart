import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_form.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_page.dart';
import 'package:proyek_akhir_semester/ReviewBook/widgets/reviewbook_widgets.dart';
import 'package:proyek_akhir_semester/models/review.dart';

class ReviewsWidget extends StatelessWidget {
  int bookId;
  List<Review> reviews;
    ReviewsWidget({
      required this.reviews, required this.bookId
    });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 150
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(this.reviews.length == 0)Center(
            child: Text('Belum ada review', style: TextStyle(color: Colors.black, fontSize: 12),),
          ),
          ...reviews.map((e) => ReviewItem(userId: e.user.id, bookId: bookId, reviewId: e.id,username: e.user.username, rating: e.rating, reviewText: e.content,photo: e.photoUrl,profileImage: e.user.profilePicture??'')).toList().sublist(0, reviews.length > 2? 2 : reviews.length)
        ],
      ),
    );
  }
}
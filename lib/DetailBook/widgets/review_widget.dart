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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                           return DaftarReview(bookId: bookId,);
                         }));
            }, icon: Icon(Icons.add, color: Colors.black),)
          ],
        ),
        ...reviews.map((e) => ReviewItem(username: e.user.username, rating: e.rating, reviewText: e.content, profileImage: e.photoUrl??'')).toList().sublist(0, reviews.length > 2? 2 : reviews.length)
      ],
    );
  }
}
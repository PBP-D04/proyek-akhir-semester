import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/product_mini_image.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_form.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';

// Tampilan desain ulasan 

class ReviewItem extends ConsumerWidget {
  final int userId;
  final String username;
  final int rating;
  final String reviewText;
  final String profileImage;
  String? bookImage;
  final int reviewId;
  final int bookId;

  ReviewItem({
    required this.reviewId,
    required this.bookId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.profileImage,
    this.bookImage,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(authProvider);
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage.isEmpty? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png':profileImage),
                radius: 20.0,
              ),
              SizedBox(width: 12.0),
              Text(
                user == null? username : user.id == userId? 'Anda' : username,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8,),
              Spacer(),
              if (user != null && user.id == userId)
                IconButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return ReviewFormPage(bookId: bookId, reviewId: reviewId,);
                    }));
                  },
                  icon: Icon(Icons.edit, color: Colors.black),
                ),

            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                Icons.star,
                color: index < rating ? Colors.yellow : Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(reviewText),
          SizedBox(height: 8.0),
         if(bookImage != null && bookImage!.isNotEmpty) SizedBox(
           height: 120,
           child: ProductMiniImage(isSelected: false,function: (str){}, imageData: bookImage!,),
         )
        ],
      ),
    );
  }
}
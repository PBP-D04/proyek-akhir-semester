import 'package:flutter/material.dart';
class ReviewItem extends StatelessWidget {
  final String username;
  final int rating;
  final String reviewText;
  final String profileImage;

  ReviewItem({
    required this.username,
    required this.rating,
    required this.reviewText,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 20.0,
              ),
              SizedBox(width: 12.0),
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
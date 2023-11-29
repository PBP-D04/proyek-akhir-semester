import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final String username;
  final String reviewText;
  final String? profileImage;

  CommentItem({
    required this.username,
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
                backgroundImage: NetworkImage(profileImage == null? 'https://www.waifu.com.mx/wp-content/uploads/2023/05/Waifu-Wishlist-Must-Have-Traits-and-Qualities-in-a-Beloved-Character.jpg': profileImage!.trim().isEmpty? 'https://www.waifu.com.mx/wp-content/uploads/2023/05/Waifu-Wishlist-Must-Have-Traits-and-Qualities-in-a-Beloved-Character.jpg': profileImage!),
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
        
          Text(reviewText),
        ],
      ),
    );
  }
}
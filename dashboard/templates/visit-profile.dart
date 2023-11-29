import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String profilePicture;
  final String username;
  final String fullname;
  final List<String> bookThumbnails;
  final List<ReviewData> reviews;

  UserProfileScreen({
    required this.profilePicture,
    required this.username,
    required this.fullname,
    required this.bookThumbnails,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookphoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profilePicture),
                    radius: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fullname,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "$username's Books",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (String thumbnail in bookThumbnails)
                          Image.network(
                            thumbnail,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 400,
                    child: ListView(
                      children: [
                        for (ReviewData review in reviews)
                          ReviewWidget(review: review),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewData {
  final String thumbnail;
  final String title;
  final double rating;
  final String content;

  ReviewData({
    required this.thumbnail,
    required this.title,
    required this.rating,
    required this.content,
  });
}

class ReviewWidget extends StatelessWidget {
  final ReviewData review;

  ReviewWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.network(review.thumbnail, height: 100, width: 100),
          SizedBox(height: 10),
          Text(
            review.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.star),
              Text(review.rating.toString()),
            ],
          ),
          SizedBox(height: 10),
          Text(review.content),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfileScreen(
      profilePicture: 'URL_TO_PROFILE_PICTURE',
      username: 'Username',
      fullname: 'Full Name',
      bookThumbnails: [
        'BOOK_THUMBNAIL_URL_1',
        'BOOK_THUMBNAIL_URL_2',
        // Add more book thumbnails
      ],
      reviews: [
        ReviewData(
          thumbnail: 'REVIEW_THUMBNAIL_URL_1',
          title: 'Review Title 1',
          rating: 4.5,
          content: 'Review content 1...',
        ),
        ReviewData(
          thumbnail: 'REVIEW_THUMBNAIL_URL_2',
          title: 'Review Title 2',
          rating: 3.0,
          content: 'Review content 2...',
        ),
        // Add more reviews
      ],
    ),
  ));
}


import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Review> reviews = [];
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    refreshBookList();
    refreshReviewList();
  }

  Future<void> refreshBookList() async {
    // Fetch books data from your API endpoint
    // Example API call: /profile/get-books
    // Update the books list
    setState(() {
      books = []; // Update with actual data
    });
  }

  Future<void> refreshReviewList() async {
    // Fetch reviews data from your API endpoint
    // Example API call: /profile/get-reviews
    // Update the reviews list
    setState(() {
      reviews = []; // Update with actual data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookphoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: books.isEmpty,
              child: Column(
                children: [
                  Text(
                    'User does not exist',
                    style: TextStyle(fontSize: 20, opacity: 0.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  for (Review review in reviews)
                    ReviewWidget(review: review),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle adding a new book
                // You might want to show a modal bottom sheet or navigate to a new screen for adding a book
              },
              child: Text('Add More Book'),
            ),
          ],
        ),
      ),
    );
  }
}

class Review {
  final String thumbnail;
  final String title;
  final double rating;
  final String content;

  Review({required this.thumbnail, required this.title, required this.rating, required this.content});
}

class Book {
  final String thumbnail;

  Book({required this.thumbnail});
}

class ReviewWidget extends StatelessWidget {
  final Review review;

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
    home: ProfileScreen(),
  ));
}

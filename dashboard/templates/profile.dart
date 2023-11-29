import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookphoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserProfileSection(),
            SizedBox(height: 20),
            RecentReviewsSection(),
            SizedBox(height: 20),
            AddBookButton(),
          ],
        ),
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with your logic to get user data
    // For now, using placeholder data
    String username = 'JohnDoe';
    String fullName = 'John Doe';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage('https://example.com/user_profile_picture.jpg'),
          radius: 50,
        ),
        SizedBox(height: 10),
        Text(
          username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(fullName),
        SizedBox(height: 10),
        Text("$username's Books", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        // Add the book list here
      ],
    );
  }
}

class RecentReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        // Add the recent reviews list here
      ],
    );
  }
}

class AddBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle adding a new book
        // You might want to show a modal bottom sheet or navigate to a new screen for adding a book
      },
      child: Text('Add More Book'),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}

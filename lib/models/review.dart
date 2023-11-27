import 'package:proyek_akhir_semester/models/user.dart';
class Review {
  final int id;
  final User user;
  final int bookId;
  final String content;
  final int rating;
  final String? photoUrl;
  final String dateAdded;

  Review({
    required this.id,
    required this.user,
    required this.bookId,
    required this.content,
    required this.rating,
    this.photoUrl,
    required this.dateAdded,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      user: User.fromJson(json['user']),
      bookId: json['book_id'],
      content: json['content'],
      rating: json['rating'],
      photoUrl: json['photo_url'],
      dateAdded: json['date_added'],
    );
  }
}
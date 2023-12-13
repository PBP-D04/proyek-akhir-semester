import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/models/user.dart';
import 'package:proyek_akhir_semester/Homepage/models/like.dart';
class Book {
  User user;
  final int id;
  final String title;
  final String? subtitle;
  String? description;
  final List<String> authors;
  String? publisher;
  String? publishedDate;
  String? language;
  String? currencyCode;
  final bool isEbook;
  final bool pdfAvailable;
  String? pdfLink;
  final String thumbnail;
  final List<String> categories;
  final List<String> images;
  String? price;
  final bool saleability;
  String? buyLink;
  final bool epubAvailable;
  String? epubLink;
  final String maturityRating;
  final int pageCount;
  final String userPublishTime;
  final List<Like> likes;
  final List<Review> reviews; // List of reviews associated with the book

  Book({
    required this.likes,
    required this.user,
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.language,
    this.currencyCode,
    required this.isEbook,
    required this.pdfAvailable,
    this.pdfLink,
    required this.thumbnail,
    required this.categories,
    required this.images,
    required this.price,
    required this.saleability,
    this.buyLink,
    required this.epubAvailable,
    this.epubLink,
    required this.maturityRating,
    required this.pageCount,
    required this.userPublishTime,
    required this.reviews,
  });

  double calculateAverageStars() {
    if (reviews.isEmpty) {
      return 0.0; // Jika tidak ada ulasan, rata-rata bintang adalah 0
    }

    int totalStars = 0;
    for (Review review in reviews) {
      totalStars += review.rating;
    }

    double averageStars = totalStars / reviews.length;
    return averageStars;
  }

  factory Book.fromJson(Map<String, dynamic> json, User user) {
    // Parse review data into Review objects
    List<Review> reviewsList = [];
    List<Like> initialLikes = [];

    for (var likeData in json['book_likes']) {
      Like like = Like.fromJson(likeData);
      initialLikes.add(like);
    }
    // Parse book data
    return Book(
      likes: initialLikes,
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      authors: List<String>.from(json['authors']),
      publisher: json['publisher'],
      publishedDate: json['published_date'],
      language: json['language'],
      currencyCode: json['currencyCode'],
      isEbook: json['is_ebook'],
      pdfAvailable: json['pdf_available'],
      pdfLink: json['pdf_link'],
      thumbnail: json['thumbnail'],
      categories: List<String>.from(json['categories']),
      images: List<String>.from(json['images']),
      price: json['price'],
      saleability: json['saleability'],
      buyLink: json['buy_link'],
      epubAvailable: json['epub_available'],
      epubLink: json['epub_link'],
      maturityRating: json['maturity_rating'],
      pageCount: json['page_count'],
      userPublishTime: json['user_publish_time'],
      reviews: reviewsList,
      user: user,
    );
  }
}




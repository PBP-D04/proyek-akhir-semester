import 'package:proyek_akhir_semester/models/user.dart';

class Comment{
  String username;
  String? profilePicture;
  int bookId;
  int userId;
  String content;
  DateTime createdAt;
  Comment({required this.username,required this.profilePicture, required this.bookId, required this.userId, required this.content, required this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      userId: json['user_id'],
      bookId: json['book'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      profilePicture: json['profile_picture']??'',
      username: json['username'],
    );
  }
}

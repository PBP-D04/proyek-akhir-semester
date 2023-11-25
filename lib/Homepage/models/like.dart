class Like {
  int userId;
  int likedBookId;
  DateTime createdAt;

  Like({

    required this.userId,
    required this.likedBookId,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(

      userId: json['user_id'],
      likedBookId: json['liked_book_id'],
      createdAt: DateTime.parse(json['created_at']),
      // Tambahkan atribut lainnya jika diperlukan
    );
  }
}
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/rating.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

import '../models/book.dart';
class BookListTile extends StatelessWidget {
  final Book book;
  ResponsiveValue _responsiveValue = ResponsiveValue();

  BookListTile({required this.book});

  @override
  Widget build(BuildContext context) {
    _responsiveValue.setResponsive(context);
    return ListTile(
      leading: CircleAvatar(
        // Gambar buku (jika ada) dapat ditambahkan di sini
        backgroundImage: NetworkImage(book.thumbnail), // Contoh menggunakan huruf pertama dari judul
      ),
      title: Text(book.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: _responsiveValue.subtitleFontSize),),
      subtitle: Row(
        children: [
          StarRating(book.calculateAverageStars()),
          Text(book.calculateAverageStars().toStringAsFixed(1), style: TextStyle(fontSize: _responsiveValue.contentFontSize),),
          SizedBox(width: 8),
          Icon(Icons.rate_review),
          Text(book.reviews.length.toString(), style: TextStyle(fontSize: _responsiveValue.contentFontSize),),
        ],
      ),
      onTap: () {
        // Tambahkan aksi ketika item dipilih
      },
    );
  }
}
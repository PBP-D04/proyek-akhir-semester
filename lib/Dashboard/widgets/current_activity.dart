

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Dashboard/models/current_activity_model.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_tile.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/time.dart';

import '../../Homepage/models/book.dart';
import '../../Homepage/models/history.dart';
import '../../models/user.dart';

class CurrentActivityWidget extends ConsumerWidget{
  CurrentActivity currentActivity;
  CurrentActivityWidget({super.key, required this.currentActivity});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final currentUser = ref.watch(authProvider);
    Map<int, Book> books = ref.watch(booksProvider);
    if (currentActivity.data.runtimeType == Review) {
      // Jika tipe data adalah Review
      Review dataReview = currentActivity.data;
      String subtitleText =
      dataReview.content.trim().isEmpty ? "Tidak ada komentar" : dataReview.content;
      // Lakukan sesuatu dengan dataReview
      return books[dataReview.bookId] != null?Container(
        child: Column(
          children: [
            if(books[dataReview.bookId] != null)BookListTile(book: books[dataReview.bookId]!),
            ListTile(
              title: Text('${currentUser == null ? currentActivity.user.username : currentUser!.id != currentActivity.user.id ? currentActivity.user.username: 'Anda'} memberikan review', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              subtitle: Text(subtitleText, style: TextStyle(color: Colors.black)),
              trailing: Text(formatTimeAgoDate(dataReview.dateAdded), style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ):Container();;
    } else if (currentActivity.data.runtimeType == History) {
      // Jika tipe data adalah History
      History historyData = currentActivity.data;
      // Lakukan sesuatu dengan historyData
      return ListTile(
        title: Text('Anda membuat pencarian:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        subtitle: Text(historyData.text, style: TextStyle(color: Colors.black)),
        trailing: Text(formatTimeAgoDate(historyData.time), style: TextStyle(color: Colors.black)),
      );
    } else if (currentActivity.data.runtimeType == Comment) {
      // Jika tipe data adalah Comment
      Comment commentData = currentActivity.data;
      String subtitleText =
      commentData.content.trim().isEmpty ? "Tidak ada komentar" : commentData.content;
      // Lakukan sesuatu dengan commentData
      return books[commentData.bookId] != null?Container(
        child: Column(
          children: [
            if(books[commentData.bookId] != null)BookListTile(book: books[commentData.bookId]!),
            ListTile(
              title: Text('${currentUser == null ? currentActivity.user.username : currentUser!.id != currentActivity.user.id ? currentActivity.user.username: 'Anda'} memberikan komentar:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              subtitle: Text(subtitleText, style: TextStyle(color: Colors.black)),
              trailing: Text(formatTimeAgoDate(commentData.createdAt), style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ):Container();
    } else {
      // Jika tipe data tidak dikenali atau kosong
      return Container(
        child: Text('Tipe data tidak dikenali'),
      );
    }}}
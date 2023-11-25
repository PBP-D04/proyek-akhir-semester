import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/api/api_config.dart' as api;
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/util/provider_helper.dart';

import '../../models/user.dart';
import '../models/book.dart';

Future<String> fetchProduct(BuildContext context, WidgetRef ref) async {
  const baseUrlStr = api.BASE_URL;
  final url = Uri.parse('$baseUrlStr/get-books-json/');
  try{
    final responseJson = await http.get(url);
    final res = await jsonDecode(responseJson.body);
   //print(res['book_list'][0]);
    final book_list_raw = res['book_list'];
    Map<int, Book> booksMap = {};
    book_list_raw.forEach((bookData){
      //print('OK BERHASIL');
      User user = User.fromJson(bookData['user']);
     // print(user);
      Book book = Book.fromJson(bookData['book'], user);
      //print(book);
      for (var reviewData in bookData['review']) {
       // print('HERE');
        Review review = Review.fromJson(reviewData);
        book.reviews.add(review);
      }
      booksMap[book.id] = book;
    });
    ref.read(booksProvider.notifier).setItems(booksMap);
    ref.read(carouselBooksProvider.notifier).setItems(takeFiveRandomSamples(booksMap));
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
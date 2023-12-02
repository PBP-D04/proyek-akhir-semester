
import 'dart:convert';

import '../../Homepage/models/book.dart';
import '../../api/api_config.dart';
import 'package:http/http.dart' as http;

Future<String> submitBook(Book book, bool isEdit, int bookIdToEdit) async {
  final data = {
    'book_id':bookIdToEdit,
      'user_id': book.user.id,
      'title':book.title,
      'subtitle':book.subtitle,
      'description':book.description,
    'publisher':book.publisher,
    'published_date':book.publishedDate,
    'language': book.language,
    'currency_code':'Rp',
    'is_ebook':book.isEbook,
    'images':book.images,
    'categories':book.categories,
    'pdf_available':book.pdfAvailable,
    'pdf_link':book.pdfLink,
    'thumbnail':book.thumbnail,
    'price':book.price,
    'saleability':book.saleability,
    'buy_link':book.buyLink,
    'epub_available':book.epubAvailable,
    'epub_link':book.epubLink,
    'maturity_rating':book.maturityRating,
    'page_count':book.pageCount,
    'authors':book.authors
  };
  print(data);
  const baseUrlStr = BASE_URL;
  var url = Uri.parse('$baseUrlStr/profile/create-book-flutter/');
  if(isEdit){
    url = Uri.parse('$baseUrlStr/profile/edit-book-flutter/');
  }
  try{
    final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );
    final res = await jsonDecode(response.body);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
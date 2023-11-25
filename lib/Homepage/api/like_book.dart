
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/models/user.dart';
import 'package:http/http.dart' as http;

Future<void> likeOrDislikeBook(User? user, Book book, context) async {
  if(user == null){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum login')));
    return;
  }
  const urlStr = '$BASE_URL/update-like/';
  final Map<String,int> data = {
    'bookId': book.id, // Pastikan ini adalah field yang benar untuk ID buku
    'userId': user.id, // Pastikan ini adalah field yang benar untuk ID pengguna
  };
  try {
    final response = await http.post(
      Uri.parse(urlStr),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );

  } catch (error) {
    print('Error: $error');
    // Tangani kesalahan seperti masalah koneksi atau kesalahan server
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
  }
}
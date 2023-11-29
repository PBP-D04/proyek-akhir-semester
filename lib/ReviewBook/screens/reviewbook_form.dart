import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/rating.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';

class ReviewFormPage extends ConsumerStatefulWidget {
  int bookId;
  ReviewFormPage({super.key, required this.bookId});

  @override
  ConsumerState<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends ConsumerState<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _starRating = 1;
  String _comment = "";
  @override

  Future<void> reviewBook(context, ref) async {
    final user = ref.watch(authProvider);
    final book = ref.watch(booksProvider);
    final selectedBook = book[widget.bookId];
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum login')));
      return;
    }
    if(selectedBook == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Buku telah terhapus')));
      return;
    }
    print('semoga bisaaaaaaaaaaaa');
    const urlStr = '$BASE_URL/review/add-review-flutter/';
    final data = {
        'user_id':user.id,
        'book_id':selectedBook.id,
        'rating':_starRating,
        'content':_comment,
        'photo': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKazETeZCBVzGuEHvbfRheh5zg1Q38fp4blA&usqp=CAU'
    };
    try {
      final response = await http.post(
        Uri.parse(urlStr),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data)
      );
      print('aaaaaaaaaaaaaaaaakkkkkkk');

    } catch (error) {
      print('Error: $error');
      // Tangani kesalahan seperti masalah koneksi atau kesalahan server
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>(); 
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Form Ulasan'),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      // drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Bintang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _starRating,
                  items: List.generate(5, (index) => index + 1)
                      .map<DropdownMenuItem<int>>(
                          (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value Bintang'),
                              ))
                      .toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _starRating = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'Mohon pilih jumlah bintang';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Tulis komentar Anda di sini...",
                    labelText: "Komentar (Opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _comment = value ?? '';
                    });
                  },
                  maxLines: 3,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan data ulasan
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Ulasan berhasil tersimpan'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Bintang: $_starRating'),
                                    Text('Komentar: $_comment'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        reviewBook(context, ref);
                      }
                    },
                    child: const Text(
                      "Simpan Ulasan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
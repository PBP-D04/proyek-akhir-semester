import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/preview_image.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/rating.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/api/cloudinary._api.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/download_file.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

import '../../models/review.dart';

class ReviewFormPage extends ConsumerStatefulWidget {
  int bookId;
  int? reviewId;
  ReviewFormPage({super.key, required this.bookId, this.reviewId});

  @override
  ConsumerState<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends ConsumerState<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  ResponsiveValue rsval = ResponsiveValue();
  int _starRating = 1;
  String _comment = "";
  File? imageFile;
  Uint8List? imageData;
  bool isEditUlasan = false;

  @override
  void initState(){
    super.initState();

  }

  @override
  void didChangeDependencies(){
    print('hello');
    initEdit();
  }

  Future<void> initEdit()async{
    if(widget.reviewId != null){
      Review? review = ref.watch(reviewListProvider)[widget.reviewId];
      if(review != null){
          _starRating = review.rating;
          _comment = review.content;
          isEditUlasan = true;
        if(review.photoUrl != null){
          if(review.photoUrl!.trim().isNotEmpty){
            XFile? xfile = await xFileFromImageUrl(review.photoUrl!);
            if(xfile != null){

              final data = await xfile.readAsBytes();
              setState(() {
                imageFile = File(xfile.path);
                imageData = data;
              });
            }
          }
        }

      }
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final data = await pickedFile.readAsBytes();
      setState(() {
        imageFile = file;
        imageData = data;
      });
    }
  }
  Future<String?> reviewBook(context, ref) async {
    final user = ref.watch(authProvider);
    final book = ref.watch(booksProvider);
    final selectedBook = book[widget.bookId];
    String? resImage;

    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum login')));
      return 'FAILED';
    }
    if(selectedBook == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Buku telah terhapus')));
      return 'FAILED';
    }
    print('semoga bisaaaaaaaaaaaa');
    if(imageFile != null && imageData != null){
      resImage = await uploadImageToCloudinaryPublicFromByteData(imageData!);
    }
    String urlStr = '$BASE_URL/review/add-review-flutter/';
    if(this.isEditUlasan){
      urlStr = '$BASE_URL/review/update-review-flutter/';
    }
    final data = {
        'user_id':user.id,
        'book_id':selectedBook.id,
        'rating':_starRating,
        'content':_comment,
        'photo': resImage??'',
      'review_id': widget.reviewId
    };
    try {
      final response = await http.post(
        Uri.parse(urlStr),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data)
      );
      print('aaaaaaaaaaaaaaaaakkkkkkk');
      return 'SUCCESS';

    } catch (error) {
      print('Error: $error');
      // Tangani kesalahan seperti masalah koneksi atau kesalahan server
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
      return 'FAILED';
    }
  }
    @override
  Widget build(BuildContext context) {
    rsval.setResponsive(context);
    // final request = context.watch<CookieRequest>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final reviews = ref.watch(reviewListProvider);
      if (reviews[widget.reviewId] == null && this.isEditUlasan) {
        Navigator.of(context).pop();
      }
      if(reviews[widget.reviewId] != null && !this.isEditUlasan){
        Navigator.of(context).pop();
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:  Center(
          child: Text('Form Ulasan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigoAccent.shade700 ),),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      // drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(this.isEditUlasan)Padding(padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: () async {
                          const urlStr = '$BASE_URL/review/delete-review-flutter/';
                          final data = {
                          'review_id':widget.reviewId
                          };
                          final response = await http.post(
                          Uri.parse(urlStr),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode(data)
                          );

                    }, icon: Icon(Icons.delete, color: Colors.black,))
                  ],
                ),
              ),
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
              Padding(padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Foto', style: TextStyle(color: Colors.black, fontSize: rsval.titleFontSize),),
                  IconButton(onPressed: (){
                    _pickPhoto();
                  }, icon: Icon(Icons.add_circle, color: Colors.black,))
                ],
              ),),
              Padding(padding: EdgeInsets.all(8),
              child: Container(
                height: 200,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: imageFile != null? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    if(imageFile == null) Center(child: Text('Tidak Ada Gambar', style:
                    TextStyle(color: Colors.black, fontSize: rsval.contentFontSize ),),),
                    if(imageFile != null && imageData != null) MiniImage(imageData: imageData!, function: (){
                      setState(() {
                        imageFile = null;
                        imageData = null;
                      });
                    })

                  ],
                ),
              ),),
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
                  initialValue: _comment,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.indigoAccent.shade700,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate())  {
                       final res = await reviewBook(context, ref);
                        // Simpan data ulasan
                       if(res == 'FAILED'){
                         return;
                       }
                       Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Ulasan berhasil tersimpan'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Bintang: $_starRating', style: TextStyle(color: Colors.black),),
                                    Text('Komentar: $_comment', style: TextStyle(color: Colors.black),),
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


                      }
                    },
                    child:  Text(
                      isEditUlasan == true? "Perbarui Ulasan":"Simpan Ulasan",
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
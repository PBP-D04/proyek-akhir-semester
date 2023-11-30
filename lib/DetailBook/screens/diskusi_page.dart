
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/comment_item.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class Diskusi extends ConsumerStatefulWidget {
  final int productId;
  Diskusi({required this.productId});
  @override
  _DiskusiState createState() => _DiskusiState();
}

class _DiskusiState extends ConsumerState<Diskusi> {
  TextEditingController controller = TextEditingController();
  ResponsiveValue responsiveValue = ResponsiveValue();
  Future<String> addComment(String text) async {
    final user =ref.watch(authProvider);
    if (user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum login')));
      return 'Unauthorized';
    }

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda tidak menulis apapun')));
      return 'Kosong';
    }

    final url = Uri.parse(BASE_URL+'/detail/add-comment-flutter/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        // Add other parameters as needed
        'user_id':user.id,
        'book_id':widget.productId,
        'content':text,
      }),
    );
    setState(() {
      controller.text = '';
    });
    return 'Success';
  }
  @override
  Widget build(BuildContext context) {

    final user =ref.watch(authProvider);
     final comments = ref.watch(commentNotifierProvider);
    List<Comment> selectedComment = comments.where((element) => element.bookId == widget.productId).toList().reversed.toList();
    responsiveValue.setResponsive(context);
    return Container(height: MediaQuery.of(context).size.height * 0.85, padding: EdgeInsets.all(12),

      child:
         Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Forum Diskusi', style: TextStyle(color: Colors.indigoAccent.shade700,fontWeight: FontWeight.bold, fontSize: responsiveValue.extraTitleFontSize),)
              ],
            ),
            SizedBox(height: 8,),
            if(user == null) Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                    padding: EdgeInsets.all(12), // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: responsiveValue.titleFontSize, // Ukuran teks
                      color: Colors.white, // Warna teks
                      fontWeight: FontWeight.bold, // Gaya teks
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                    padding: EdgeInsets.all(12), // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: responsiveValue.titleFontSize, // Ukuran teks
                      color: Colors.white, // Warna teks
                      fontWeight: FontWeight.bold, // Gaya teks
                    ),
                  ),
                ),
              ],
            ),
            if(user != null) Row(
              children: [
                Expanded(child: TextField(
                  controller: controller,
                  maxLines: 2, // Jumlah minimum baris
                  decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    filled: true,
                    fillColor: Colors.grey[200], // Warna latar belakang
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // Menghilangkan garis tepi
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Warna garis tepi saat fokus
                        width: 2.0,
                      ),
                    ),
                  ),
                )
                ),
                IconButton(onPressed: (){
                  addComment(controller.text);
                }, icon: Icon(Icons.send))
              ],
            ),
            Expanded(child: selectedComment.length > 0 ?ListView.builder(itemCount: selectedComment.length,itemBuilder: (context, index){
              return CommentItem(createdAt: selectedComment.elementAt(index).createdAt , userId: selectedComment.elementAt(index).userId, username: selectedComment.elementAt(index).username, reviewText: selectedComment.elementAt(index).content, profileImage: selectedComment.elementAt(index).profilePicture);
            }): Center(child: Text('Belum ada komentar', style: TextStyle(color: Colors.black),),))
          ],
        ),);
  }
  }


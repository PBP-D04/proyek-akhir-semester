
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/comment_item.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:http/http.dart' as http;

class Diskusi extends ConsumerStatefulWidget {
  final int productId;
  Diskusi({required this.productId});
  @override
  _DiskusiState createState() => _DiskusiState();
}

class _DiskusiState extends ConsumerState<Diskusi> {
  TextEditingController controller = TextEditingController();
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
    return 'Success';
  }
  @override
  Widget build(BuildContext context) {
     final comments = ref.watch(commentNotifierProvider);
    List<Comment> selectedComment = comments.where((element) => element.bookId == widget.productId).toList();
    return Container(height: MediaQuery.of(context).size.height * 0.85, padding: EdgeInsets.all(12), child:
         Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(
                  controller: controller,
                  
                )),
                IconButton(onPressed: (){
                  addComment(controller.text);
                }, icon: Icon(Icons.send))
              ],
            ),
            Expanded(child: ListView.builder(itemCount: selectedComment.length,itemBuilder: (context, index){
              return CommentItem(username: selectedComment.elementAt(index).username, reviewText: selectedComment.elementAt(index).content, profileImage: selectedComment.elementAt(index).profilePicture);
            }))
          ],
        ),);
  }
  }


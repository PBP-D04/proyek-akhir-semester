import 'dart:convert';

import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/models/review.dart';

import '../../api/api_config.dart';
import '../../util/parent_ref_singleton.dart';
import 'package:http/http.dart' as http;

Future<String> fetchComment() async {
  final ref = WidgetRefSingleton.instance.getRef!;
  const baseUrlStr = BASE_URL;
  final url = Uri.parse('$baseUrlStr/detail/get-comment-flutter/');
  try{
    final response = await http.get(
      url,
    );

    final res = await jsonDecode(response.body);
    final comments = res['commentList'];
    List<Comment> commentList = [];
    print(comments);
    for (var json in comments){
      Comment comment = Comment.fromJson(json);
      commentList.add(comment);
    }
    ref.read(commentNotifierProvider.notifier).state = commentList;
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
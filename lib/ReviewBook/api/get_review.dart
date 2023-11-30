import 'dart:convert';

import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/models/review.dart';

import '../../api/api_config.dart';
import '../../util/parent_ref_singleton.dart';
import 'package:http/http.dart' as http;

Future<String> fetchReview() async {
  final ref = WidgetRefSingleton.instance.getRef!;
  const baseUrlStr = BASE_URL;
  final url = Uri.parse('$baseUrlStr/review/get-review-flutter/');
  try{
    final response = await http.get(
        url,
    );

    final res = await jsonDecode(response.body);
    final reviews = res['reviews'];
    print(reviews);
    Map<int, Review> reviewMap = {};
    for (var json in reviews){
      Review review = Review.fromJson(json);
      reviewMap[review.id] = review;
    }
    ref.read(reviewListProvider.notifier).setAll(reviewMap);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
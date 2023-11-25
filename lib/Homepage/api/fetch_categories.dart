import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/provider/categories_provider.dart';
import 'package:proyek_akhir_semester/api/api_config.dart' as api;
import 'package:http/http.dart' as http;


Future<String> fetchCategories(BuildContext context, WidgetRef ref) async {
  const baseUrlStr = api.BASE_URL;
  final url = Uri.parse('$baseUrlStr/get-categories/');
  try{
    final responseJson = await http.get(url);
    final res = await jsonDecode(responseJson.body);
    //print(res['book_list'][0]);
    print(res);
    List<String> categories = (res['categories'] as List<dynamic>).map((category) => category.toString()).toList();
    categories = ['All',...categories ];


    ref.read(categoriesProvider.notifier).state = CategoriesState(currentSelectedCategory: 'All', categories: categories);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
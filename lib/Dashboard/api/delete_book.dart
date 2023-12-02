
import 'dart:convert';

import '../../api/api_config.dart';
import '../../util/parent_ref_singleton.dart';
import 'package:http/http.dart' as http;

Future<String> deleteBook(Map<int,int> books)async{
  //final ref = WidgetRefSingleton.instance.getRef!;
  String urlStr = '$BASE_URL/profile/delete-book/';

  final data = {
    'books': books.entries
      .map((entry) => entry.value).toList(),
  };
  try {
    final response = await http.post(
        Uri.parse(urlStr),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );
    print(response.body);
    return 'SUCCESS';
  } catch (error) {
    print('Error: $error');
    // Tangani kesalahan seperti masalah koneksi atau kesalahan server
    return 'FAILED';
  }
}
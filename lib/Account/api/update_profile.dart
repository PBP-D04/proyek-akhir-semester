import 'dart:convert';
import '../../api/api_config.dart';
import 'package:http/http.dart' as http;

Future<String> updateProfile(Map<String, dynamic> payload) async {
  String urlStr = '$BASE_URL/edit_profilejson/';
  try {
    final response = await http.post(
      Uri.parse(urlStr),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode}');
      return 'FAILED';
    }
    print(response.body);
    return 'SUCCESS';
  } catch (error) {
    print('Error: $error');
    return 'FAILED';
  }
}

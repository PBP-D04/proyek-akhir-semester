import 'dart:convert';
import '../../api/api_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getProfileById(int id) async {
  String urlStr = '$BASE_URL/get_profile/$id';
  try {
    final response = await http.get(Uri.parse(urlStr));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error: $error');
    return null;
  }
}

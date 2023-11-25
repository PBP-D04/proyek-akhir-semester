import 'package:proyek_akhir_semester/api/api_config.dart' as api;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<void> sendDummyRequest() async{
  const urlStr = '${api.BASE_URL}/dummy/';
  await http.post(Uri.parse(urlStr));
}
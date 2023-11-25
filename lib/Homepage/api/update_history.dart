import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/Homepage/models/history.dart';
import 'package:proyek_akhir_semester/Homepage/provider/search_history_provider.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/parent_ref_singleton.dart';


Future<String> addHistory(WidgetRef ref, History history) async {
  final auth = ref.watch(authProvider);

  if(auth == null){
    print('Guest Mode');
    return 'UNAUTHORIZED';
  }
  const baseUrlStr = BASE_URL;
  final data = {
    'userId': auth.id,
    ...history.toJson()
  };
  final url = Uri.parse('$baseUrlStr/search-history/add/');
  try{
    final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );
    final res = await jsonDecode(response.body);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}

Future<String> deleteAllHistory(History history) async {
  final ref = WidgetRefSingleton.instance.getRef!;
  final auth = ref.watch(authProvider);
  if(auth == null){
    print('Guest Mode');
    return 'UNAUTHORIZED';
  }
  const baseUrlStr = BASE_URL;
  final data = {
    'userId': auth.id,
    ...history.toJson()
  };
  final url = Uri.parse('$baseUrlStr/search-history/delete-all/');
  try{
    final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );

    final res = await jsonDecode(response.body);
    final history = res['history'];
    print(history);
    List<History> histories = [];
    for (var json in history){
      History history = History.fromJson(json);
      histories.add(history);
    }
    ref.read(historyProvider.notifier).setAllHistory(histories);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}

Future<String> deleteHistory(History history) async {
  final ref = WidgetRefSingleton.instance.getRef!;
  final auth = ref.watch(authProvider);
  if(auth == null){
    print('Guest Mode');
    return 'UNAUTHORIZED';
  }
  const baseUrlStr = BASE_URL;
  final data = {
    'userId': auth.id,
    ...history.toJson()
  };
  final url = Uri.parse('$baseUrlStr/search-history/delete/');
  try{
    final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );

    final res = await jsonDecode(response.body);
    final history = res['history'];
    print(history);
    List<History> histories = [];
    for (var json in history){
      History history = History.fromJson(json);
      histories.add(history);
    }
    ref.read(historyProvider.notifier).setAllHistory(histories);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}


Future<String> fetchHistory() async {
  final ref = WidgetRefSingleton.instance.getRef!;
  final auth = ref.watch(authProvider);
  if(auth == null){
    print('Guest Mode');
    return 'UNAUTHORIZED';
  }
  const baseUrlStr = BASE_URL;
  final data = {
    'userId': auth.id,
  };
  final url = Uri.parse('$baseUrlStr/search-history/get/');
  try{
    final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data)
    );

    final res = await jsonDecode(response.body);
    final history = res['history'];
    print(history);
    List<History> histories = [];
    for (var json in history){
      History history = History.fromJson(json);
      histories.add(history);
    }
    ref.read(historyProvider.notifier).setAllHistory(histories);
    return 'SUCCESS';
  }
  catch(err){
    print(err);
    return 'FAILED';
  }
}
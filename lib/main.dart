import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proyek_akhir_semester/DetailBook/api/fetch_comment.dart';

import 'package:proyek_akhir_semester/Homepage/api/fetch_books.dart';
import 'package:proyek_akhir_semester/Homepage/api/fetch_categories.dart';
import 'package:proyek_akhir_semester/ReviewBook/api/get_review.dart';

import 'package:proyek_akhir_semester/api/socket.dart';

import 'package:proyek_akhir_semester/screen/content_page.dart';

import 'package:proyek_akhir_semester/util/parent_ref_singleton.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}
class App extends ConsumerStatefulWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _AppState();
  }
}
class _AppState extends ConsumerState {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetRefSingleton.instance.setRef(ref);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initPusher(context, ref);
      fetchProduct(context, ref);
      fetchComment();
      fetchCategories(context, ref);
      fetchReview();
    }); // AGAR TIDAK MENGGANGGU PEMBUATAN WIDGET, DI-WRAP DENGAN WIDGETSBINDING

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  MaterialApp(
      title: 'Bookphoria',
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ContentPage(),
      },
    );
  }}

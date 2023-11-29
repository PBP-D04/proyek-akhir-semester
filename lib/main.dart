import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/Homepage/api/fetch_books.dart';
import 'package:proyek_akhir_semester/Homepage/api/fetch_categories.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/api/socket.dart';
import 'package:proyek_akhir_semester/screen/coba_login.dart';
import 'package:proyek_akhir_semester/screen/content_page.dart';
import 'package:proyek_akhir_semester/util/parent_ref_singleton.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  Future<void> fetchComment() async {
    final url = Uri.parse(BASE_URL+'/detail/get-comment-flutter/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
      }),
    );
    final responseData = jsonDecode(response.body);
    final commentList = responseData['commentList'];
    List<Comment> comments = [];
    for(final comment in comments){
      Comment commentObj = Comment.fromJson(comment as Map<String, dynamic>);
    }
    ref.read(commentNotifierProvider.notifier).state = comments;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initPusher(context, ref);
      fetchProduct(context, ref);
      fetchComment();
      fetchCategories(context, ref);
    }); // AGAR TIDAK MENGGANGGU PEMBUATAN WIDGET, DI-WRAP DENGAN WIDGETSBINDING
    WidgetRefSingleton.instance.setRef(ref);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  MaterialApp(
      title: 'Bookphoria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginPageDummy(),
        '/app': (context) => ContentPage(key: UniqueKey(),),
      },
    );
  }}

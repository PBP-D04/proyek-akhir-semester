import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Account/screens/login_page.dart';
import 'package:proyek_akhir_semester/Account/screens/register_page.dart';
import 'package:proyek_akhir_semester/Homepage/api/like_book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_tile.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';

import '../models/book.dart';

class WishlistPage extends ConsumerWidget{
  final GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> key2 = GlobalKey<ScaffoldState>();
  ResponsiveValue responsiveValue = ResponsiveValue();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    if(user == null){
      return Scaffold(
        key: key2,
        appBar: MyAppBar(scaffoldKey: key2, title: 'Wishlist Books',),
        drawer: MyDrawer(callBack: (identifier){

        }),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, color: Colors.black, size: 3 * responsiveValue.extraTitleFontSize + 24,)
                ],
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text('Kamu tidak dapat mengakses halaman ini karena masuk sebagai guest', textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: responsiveValue.subtitleFontSize),))
                ],
              ),
              SizedBox(height: 48,),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the register page
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                      padding: EdgeInsets.all(12), // Padding tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: responsiveValue.titleFontSize, // Ukuran teks
                        color: Colors.white, // Warna teks
                        fontWeight: FontWeight.bold, // Gaya teks
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to the register page
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                      padding: EdgeInsets.all(12), // Padding tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: responsiveValue.titleFontSize, // Ukuran teks
                        color: Colors.white, // Warna teks
                        fontWeight: FontWeight.bold, // Gaya teks
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    Map<int,Book> booksMap = ref.watch(booksProvider);
    List<Book> bookList = booksMap.entries.map((entry) => entry.value).toList();
    bookList = bookList.where((element) => element.likes.any((element) => element.userId == user!.id)).toList();
    // TODO: implement build
    return Scaffold(
      key: key1,
      appBar: MyAppBar(scaffoldKey: key1, title: 'Wishlist Books',),
      drawer: MyDrawer(callBack: (identifier){

      },),
      body: bookList.isEmpty?Container(padding: EdgeInsets.all(12), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Text( 'Kamu belum menyukai buku apapun :(', textAlign: TextAlign.center,style: TextStyle(
                color: Colors.black
              ),))
            ],
          )
        ],
      ),):ListView.builder(itemCount: bookList.length,itemBuilder: (context, index) {
        Book book = bookList.elementAt(index);
        return Row(
          children: [
            Expanded(child: BookListTile(book: book,

            )),
            SizedBox(width: 8,),
            IconButton(onPressed: () async{
              likeOrDislikeBook(user, book, context);
            },
                icon: const Icon(Icons.favorite, color: Colors.red,))
          ],
        );
      }),
    );
  }
}
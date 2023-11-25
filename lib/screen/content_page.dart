import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Homepage/api/dummy.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/Homepage/screens/homepage.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';

import '../Homepage/screens/all_books_page.dart';
import '../api/socket.dart';

class ContentPage extends ConsumerStatefulWidget {

  const ContentPage({super.key});
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  ResponsiveValue responsiveValue = ResponsiveValue();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Pastikan untuk membebaskan sumber daya PageController saat widget di-dispose.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    responsiveValue.setResponsive(context);
    return Scaffold(
      key: key,
      drawer: MyDrawer(callBack: (String identifier) {  },),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 8,),
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bookphoria', style: TextStyle(fontWeight:FontWeight.bold, fontSize:  responsiveValue.extraTitleFontSize,color: Colors.indigoAccent.shade700),),
             Flexible(child: Container(
               alignment: Alignment.centerRight,
               child: ConstrainedBox(
                 constraints: BoxConstraints(maxWidth: getScreenSize(context) == ScreenSize.small ? 150 :
                 getScreenSize(context) == ScreenSize.medium? 250 : 350 ) ,
                 child:  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     IconButton(
                       onPressed: () {
                         print('object---------------');
                         Navigator.of(context).push(MaterialPageRoute(builder: (context){
                           return SearchPage();
                         }));
                       },
                       icon: Icon(Icons.search_rounded, color: Colors.black),
                     ),
                     IconButton(
                       onPressed: () {},
                       icon: Icon(Icons.favorite_outline_rounded, color: Colors.black),
                     ),
                     IconButton(
                       onPressed: () {
                         key.currentState?.openDrawer();
                       },
                       icon: Icon(Icons.menu_rounded, color: Colors.black),
                     ),
                   ],
                 ),
               )
             ),)
            ],
          )),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat halaman berubah
          });
        },
        children: <Widget>[
          Home(),
          AllBooksPage(),
          Center(
            child: Text('belum dibuat 3'),
          ),
          Center(
            child: Text('belum dibuat 4'),
          ),
          // Tambahkan halaman lain sesuai kebutuhan
        ],
      ),
      floatingActionButton: auth != null? FloatingActionButton(
        onPressed: () {
      // Tambahkan logika yang ingin dijalankan saat tombol add book diklik
    },
    child: Icon(Icons.add), // Ikon tambah buku
    ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Gunakan selectedIndex di sini
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update selectedIndex saat ikon di bottom navigation bar dipilih
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.blue : Colors.grey,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded, color: _selectedIndex == 1 ? Colors.blue : Colors.grey,),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded, color: _selectedIndex == 2 ? Colors.blue : Colors.grey,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: _selectedIndex == 3 ? Colors.blue : Colors.grey,),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.blue, // Warna teks label untuk item yang aktif
        unselectedItemColor: Colors.grey, // Warna teks label untuk item yang tidak aktif
      ),
    );
  }
}
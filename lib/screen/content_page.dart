import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Dashboard/screens/add_book_page.dart';
import 'package:proyek_akhir_semester/Homepage/api/dummy.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/Homepage/screens/homepage.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';

import '../Dashboard/screens/dashboard.dart';
import '../Homepage/screens/all_books_page.dart';
import '../api/socket.dart';

class ContentPage extends ConsumerStatefulWidget {
  int? currentIndex;
   ContentPage({super.key, this.currentIndex});
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();
  ResponsiveValue responsiveValue = ResponsiveValue();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _selectedIndex = widget.currentIndex ?? 0;
      });
      print('p');
      print(widget.currentIndex);
      if(widget.currentIndex != null){
        print('ok');
        _pageController.animateToPage(widget.currentIndex!, duration: Duration(milliseconds: 400), curve: Curves.ease);
      }
    });
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
      key: key1,
      drawer: MyDrawer(callBack: (String identifier) {  },),
      appBar: MyAppBar(scaffoldKey: key1,),
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
          Dashboard(),
          Center(
            child: Text('belum dibuat 4'),
          ),
          // Tambahkan halaman lain sesuai kebutuhan
        ],
      ),
      floatingActionButton: auth != null? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return AddBookPage();
          }));
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
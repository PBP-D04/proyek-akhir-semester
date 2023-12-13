import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Account/screens/profile_page.dart';
import 'package:proyek_akhir_semester/Dashboard/screens/add_book_page.dart';
import 'package:proyek_akhir_semester/Homepage/api/dummy.dart';
import 'package:proyek_akhir_semester/Homepage/provider/maintain_index_page.dart';
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
  int _selectedIndex = MaintainIndexPage.indeks;
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  ResponsiveValue responsiveValue = ResponsiveValue();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage:
    widget.currentIndex == null? _selectedIndex : widget.currentIndex!
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(widget.currentIndex != null){
        setState(() {
          _selectedIndex = widget.currentIndex!;
          MaintainIndexPage.indeks = widget.currentIndex!;
        });
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
            _selectedIndex = index;
            MaintainIndexPage.indeks = index;// Update selectedIndex saat halaman berubah
          });
        },
        children: <Widget>[
          Home(),
          AllBooksPage(),
          Dashboard(),
          ProfilePage(),
          // Tambahkan halaman lain sesuai kebutuhan
        ],
      ),
      floatingActionButton: auth != null && _selectedIndex != 3? FloatingActionButton(
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
            _selectedIndex = index;
            MaintainIndexPage.indeks = index;
           // Update selectedIndex saat ikon di bottom navigation bar dipilih
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
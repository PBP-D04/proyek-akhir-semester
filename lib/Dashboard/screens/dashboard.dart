import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Account/screens/login_page.dart';
import 'package:proyek_akhir_semester/Account/screens/register_page.dart';
import 'package:proyek_akhir_semester/Dashboard/api/delete_book.dart';
import 'package:proyek_akhir_semester/Dashboard/models/current_activity_model.dart';
import 'package:proyek_akhir_semester/Dashboard/screens/add_book_page.dart';
import 'package:proyek_akhir_semester/Dashboard/widgets/current_activity.dart';
import 'package:proyek_akhir_semester/DetailBook/models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/models/history.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/search_history_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/myreviewbook_page.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

import '../../Homepage/widgets/book_card.dart';
import '../../models/responsive.dart';
import '../../models/review.dart';

class Dashboard extends ConsumerStatefulWidget{
  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}
class _DashboardState extends ConsumerState<Dashboard> with TickerProviderStateMixin{
  late TabController _tabController;
  int _activeTabIndex = 0;
  ResponsiveValue responsiveValue = ResponsiveValue();
  Map<int,int> booksToEditOrDelete = {};

  Future<void> submitDelete() async {
    final res = await deleteBook(booksToEditOrDelete);
    if(res == 'SUCCESS'){
      setState(() {
        booksToEditOrDelete = {};
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Ganti `length` dengan jumlah tab yang Anda miliki.
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  void _handleTabSelection() {
    setState(() {
      _activeTabIndex = _tabController.index; // Memperbarui _activeTabIndex saat tab berubah
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(authProvider);
    Map<int,Book> books = ref.watch(booksProvider);
    Map<int,Review> reviewsMap = ref.watch(reviewListProvider);



    if(user == null){
      return Container(
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
      );
    }
    List<Review> myReview = reviewsMap.entries
        .map((entry) => entry.value).where((element) => element.user.id == user!.id).toList();
    List<History> histories = ref.watch(historyProvider);
    List<Book>  mybook = books.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => element.user.id == user!.id).toList();
    responsiveValue.setResponsive(context);
    List<Comment> myComment = ref.watch(commentNotifierProvider).where((element) => element.userId == user!.id).toList();

    List<CurrentActivity> activities = [...myReview, ...myComment, ...histories ].map((e) => CurrentActivity(data: e, user:  user!)).toList();
    activities.sort((a,b)=>b.time.compareTo(a.time));

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(

              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.indigoAccent.shade700
              ),
              child:
              Center(
                child: LayoutBuilder(builder:(context,constraints){
                  return Container(
                    width: constraints.maxWidth > 1024 ? 1024 : constraints.maxWidth,
                    height: responsiveValue.appBarHeight,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:EdgeInsets.symmetric(horizontal: 20),

                              child: Row(
                                mainAxisAlignment:  MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width > 300 ? responsiveValue.profilePictureSize : 40,
                                    backgroundImage: NetworkImage(
                                      user!.profilePicture != null && !user!.profilePicture!.isEmpty
                                          ? user!.profilePicture!
                                          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                    ),
                                  ),

                                  Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user.fullname!,
                                              softWrap: false, // Tidak akan ada pemisahan baris
                                              overflow: TextOverflow.ellipsis, // Teks yang tidak muat akan ditampilkan dengan ellipsis (...)
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: responsiveValue.titleFontSize, // Ukuran nama lengkap
                                                fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                                              ),
                                            ),
                                            SizedBox(height: 8), // Jarak antara nama lengkap dan username
                                            Text(
                                              user.username!,
                                              style: TextStyle(
                                                  fontSize: responsiveValue.subtitleFontSize, // Ukuran username
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade200// Gaya teks username
                                              ),
                                              softWrap: false, // Tidak akan ada pemisahan baris
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4,),
                                            Text(
                                              user!.phoneNumber!,
                                              style: TextStyle(
                                                  fontSize: responsiveValue.subtitleFontSize, // Ukuran email
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade200// Gaya teks email
                                              ),
                                              maxLines: 2, // Tidak akan ada pemisahan baris
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )),


                                ],
                              ),
                            ),
                            SizedBox(height: responsiveValue.kDistance * 2,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed('/all-your-products');
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                        return DaftarReviewSaya(userId: user.id);
                                      }));
                                    // Tambahkan aksi yang ingin dilakukan saat tombol "Lihat Semua Daftar Produk" ditekan
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Warna latar belakang tombol "Lihat Semua Daftar Produk"
                                    padding: EdgeInsets.all(8), // Padding tombol
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                    ),
                                  ),
                                  child: Text(
                                    'Atur ulasanmu',
                                    style: TextStyle(
                                      fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                      color: Colors.white, // Warna teks
                                      fontWeight: FontWeight.bold, // Gaya teks
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center ,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.book, // Ikon keranjang belanja
                                          color: Colors.white, // Warna ikon
                                          size: 32, // Ukuran ikon
                                        ),
                                        SizedBox(width: 4,),
                                        Text('${mybook.length}', style: TextStyle(fontSize: responsiveValue.titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center ,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.rate_review, // Ikon keranjang belanja
                                          color: Colors.white, // Warna ikon
                                          size: 32, // Ukuran ikon
                                        ),
                                        SizedBox(width: 4,),
                                        Text('${myReview.length}', style: TextStyle(fontSize: responsiveValue.titleFontSize, fontWeight: FontWeight.bold, color: Colors.grey.shade200)),
                                      ],
                                    )
                                  ],

                                ),

                              ],
                            ),
                            SizedBox(height: 12,)
                          ],
                        )
                    ),
                  );
                }),
              )
          ),
        )
        ,
        SliverAppBar(
            expandedHeight: 20,
            pinned: true,
            floating: true,
            snap: false,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: PreferredSize(
              preferredSize: Size(double.infinity, 4),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  isScrollable:true,
                  controller: _tabController,
                  tabs: <Widget>[
                    Tab(
                      height: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding:EdgeInsets.symmetric(horizontal: 12,),
                          color: _activeTabIndex == 0? Colors.lightBlue : Colors.grey.shade600, // Warna latar belakang tab
                          child: Center(
                            child: Text(
                              'Your Books',
                              style: TextStyle(fontSize: responsiveValue.contentFontSize,color: Colors.white ), // Warna teks tab
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      height: 24,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          color: _activeTabIndex == 1? Colors.lightBlue : Colors.grey.shade600, // Warna latar belakang tab
                          child: Center(
                            child: Text(
                              'Recent',
                              style: TextStyle(fontSize: responsiveValue.contentFontSize, color: Colors.white
                              ), // Warna teks tab
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Konten untuk penjual

              LayoutBuilder(builder: (context,constraints){

                return  Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        LayoutBuilder(builder: (context,constraints){
                          return Container(
                              width: constraints.maxWidth,
                              child:Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.spaceBetween,
                                runSpacing: 8,
                                children: [
                                  Text('Your Books', style: TextStyle(
                                      fontSize: responsiveValue.titleFontSize,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(width: 8,),
                                  Container(child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if(booksToEditOrDelete.length == 1)ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pushNamed('/add-product');
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                            if(booksToEditOrDelete.isEmpty){
                                              return AddBookPage();
                                            }
                                            print('omaiwa');
                                            print('rasengan...................');
                                            return AddBookPage(bookId: booksToEditOrDelete.values.elementAt(0),);
                                          }));

                                          // Tambahkan aksi yang ingin dilakukan saat tombol "Tambah" ditekan

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigoAccent.shade700, // Warna latar belakang tombol "Tambah"
                                          padding: EdgeInsets.all(8), // Padding tombol
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                          ),
                                        ),
                                        child: Text(
                                          booksToEditOrDelete.isEmpty?'Tambah Buku':'Edit Buku',
                                          style: TextStyle(
                                            fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                            color: Colors.white, // Warna teks
                                            fontWeight: FontWeight.bold, // Gaya teks
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      if(booksToEditOrDelete.isNotEmpty)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigator.of(context).pushNamed('/all-your-products');
                                            submitDelete();
                                            // Tambahkan aksi yang ingin dilakukan saat tombol "Lihat Semua Daftar Produk" ditekan
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red, // Warna latar belakang tombol "Lihat Semua Daftar Produk"
                                            padding: EdgeInsets.all(8), // Padding tombol
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5), // Bentuk tombol dengan sudut melengkung
                                            ),
                                          ),
                                          child: Text(
                                            'Hapus Item',
                                            style: TextStyle(
                                              fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                              color: Colors.white, // Warna teks
                                              fontWeight: FontWeight.bold, // Gaya teks
                                            ),
                                          ),
                                        )
                                    ],
                                  ))
                                ],
                              ));

                        }),
                        SizedBox(height:8),
                       Expanded(child: SingleChildScrollView(
                         child:  mybook.length != 0 ?GridView.builder(
                           shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(),
                           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                             maxCrossAxisExtent: 300,
                             crossAxisSpacing: 10,
                             mainAxisSpacing: 10,
                             childAspectRatio: MediaQuery.of(context).size.width > 450 ||
                                 MediaQuery.of(context).size.width < 285? 3/6 : 3/7 ,
                           ),
                           itemCount: mybook.length,
                           itemBuilder: (BuildContext context, int index) {
                             // Tambahkan item-item Anda di sini
                             Book book = mybook.elementAt(index);
                             return Stack(
                               children: [
                                 BookCard(book: book),
                                 Positioned(child: IconButton(
                                   onPressed: (){
                                     setState(() {
                                       booksToEditOrDelete.containsKey(book.id) ? booksToEditOrDelete.remove(book.id):
                                       booksToEditOrDelete[book.id] = book.id;
                                     });
                                   },
                                   icon: Icon(booksToEditOrDelete.containsKey(book.id)? Icons.check_box : Icons.check_box_outline_blank, color: Colors.white,),
                                 ))
                               ],
                             );
                           },
                         ) : SizedBox(
                             height: MediaQuery.of(context).size.height * 0.32,
                             child: Center(
                               child:  Text('Kamu belum memiliki buku', style: TextStyle(
                                   fontSize: responsiveValue.subtitleFontSize
                               ),),
                             )
                         ),
                       ))
                      ],
                    ),
                );
              }),
              // Konten untuk pelanggan
             ListView.builder(itemCount: activities.length,itemBuilder: (context, index){
                CurrentActivity activity = activities.elementAt(index);
                return CurrentActivityWidget(currentActivity: activity);
              }),
            ],
          ),
        ),

      ],
    );
  }
}
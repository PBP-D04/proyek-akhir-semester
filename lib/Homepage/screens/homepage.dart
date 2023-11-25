import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/models/sorting_type.dart';
import 'package:proyek_akhir_semester/Homepage/provider/preference_provider.dart';
import 'package:proyek_akhir_semester/Homepage/util/provider_helper.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/welcome_widget.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_card.dart';
import '../../models/responsive.dart';
import '../../util/responsive_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Home extends ConsumerStatefulWidget{
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends ConsumerState<Home>{
  ResponsiveValue responsiveValue = ResponsiveValue();

  CarouselController _carouselController = CarouselController();
  int _carouselCurrentIndex = 0;


  List<Book> takeFiveRandomSamples(List<Book> list) {
    Random random = Random();
    List<Book> resultList = List.from(list);
    // Clone list to avoid modifying original list

    if (resultList.length <= 5) {
      return resultList;
    }

    resultList.shuffle(random);
    return resultList.sublist(0, 5);
  }
  @override
  Widget build(BuildContext context) {
    double _carouselHeight =  MediaQuery.of(context).size.width <= 300? 320 : getScreenSize(context) ==  ScreenSize.small ?250 :
    getScreenSize(context) == ScreenSize.medium ? 280 :300;
    var authUser = ref.watch(authProvider);
    var books = ref.watch(booksProvider);
    var preference = ref.watch(preferenceProvider);
    var carouselBooks = ref.watch(carouselBooksProvider);
    List<Book>  bookList = books.entries
        .map((entry) => entry.value)
        .toList().reversed.toList();
    // TODO: implement build
    responsiveValue.setResponsive(context);
    List<Book>carouselBookList = carouselBooks.entries
        .map((entry) => entry.value).toList();
    bookList = sorting(preference.sortingType, bookList);
    bookList = bookList.sublist(0, bookList.length > 12 ? 12 : bookList.length);



    return CustomScrollView(
      slivers: [
        if(!preference.isWelcomeClosed)SliverToBoxAdapter(
          child: Container(
            color: Colors.lightBlueAccent.shade400,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: WelcomeWidget(user: authUser, onClose: (){
              ref.read(preferenceProvider.notifier).updateStateWith(isWelcomeClosed: true);
            },),
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
              color: Colors.indigoAccent.shade400,
              child: CarouselSlider(
                carouselController: _carouselController ,
                options: CarouselOptions(
                    viewportFraction: 1,
                    height: _carouselHeight,
                  onPageChanged: (index, reason){
                      setState(() {
                        _carouselCurrentIndex = index;
                      });
                  }
                ),

                items: [
                  ...carouselBookList.map((book){
                    return Container(
                      padding: EdgeInsets.all(24),
                      height: _carouselHeight,
                      constraints: BoxConstraints(
                          maxWidth: 768
                      ),
                      child: Column(
                        //mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: MediaQuery.of(context).size.width > 300 ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: _carouselHeight-50,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 3/4,
                                        child: Image.network(book.thumbnail, fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Positioned(
                                        left: 8,
                                        top: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple.shade400,
                                            borderRadius: BorderRadius.circular(5),

                                          ),
                                          child: Align(
                                            child: book.saleability? Text('Rp ${book.price}',
                                              style: const TextStyle(
                                                  color: Colors.white
                                              ),): const Text('Free',
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16,),
                              Expanded(child: SizedBox(
                                  height: _carouselHeight-50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(book.title, textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                            fontSize: responsiveValue.titleFontSize),),
                                        SizedBox(height: 8,),
                                        Expanded(child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [Flexible(child: Text(book.description?? 'Tidak ada deskripsi', maxLines: 10, textAlign: TextAlign.justify, style: TextStyle(color: Colors.white,
                                            fontSize: responsiveValue.contentFontSize, overflow: TextOverflow.ellipsis ), overflow: TextOverflow.ellipsis, ),),],
                                        ),),
                                        SizedBox(height: 8,),
                                        ElevatedButton(onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                            return Center(child: Text('Please implement this'),);
                                          }));
                                        }, style:
                                        ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)), child:Text('Lihat Produk', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                            fontSize: responsiveValue.titleFontSize),) )

                                      ],
                                    ),
                                  )),)
                            ],
                          ):
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              SizedBox(
                                height: 160,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 3/4,
                                        child: Image.network(book.thumbnail, fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Positioned(
                                        left: 8,
                                        top: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple.shade400,
                                            borderRadius: BorderRadius.circular(5),

                                          ),
                                          child: Align(
                                            child: book.saleability? Text('Rp ${book.price}',
                                              style: const TextStyle(
                                                  color: Colors.white
                                              ),): const Text('Free',
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16,),
                              Expanded(child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 8,),
                                        Text(book.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                            fontSize: responsiveValue.titleFontSize),),
                                        SizedBox(height: 8,),
                                        Expanded(child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Flexible(child: Text(book.description?? 'Tidak ada deskripsi', maxLines: 10, textAlign: TextAlign.center, style: TextStyle(color: Colors.white,
                                            fontSize: responsiveValue.contentFontSize, ), overflow: TextOverflow.ellipsis, ),),],
                                        ),),
                                        SizedBox(height: 8,),
                                        ElevatedButton(onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                            return Center(child: Text('Please implement this'),);
                                          }));
                                        }, style:
                                        ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)), child:Text('Lihat Produk', textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                                            fontSize: responsiveValue.titleFontSize),) )

                                      ],
                                    ),
                                  )),)
                            ],
                          ))
                        ],
                      ),

                    );
                  }).toList()
                ],
              ) ,
            ),
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: carouselBookList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Book book = entry.value;

                    return GestureDetector(
                      onTap: () {
                        // Tambahkan logika untuk mengubah indeks aktif
                        setState(() {
                          _carouselCurrentIndex = index;
                          _carouselController.animateToPage(index);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        width: 18,
                        height: 10,
                        decoration: _carouselCurrentIndex == index ?BoxDecoration(
                          borderRadius:  BorderRadius.circular(8.0),

                          color: Colors.deepPurpleAccent.shade700
                          // Jika _carouselCurrentIndex sama dengan index, gunakan warna biru; jika tidak, gunakan warna abu-abu
                        ) :
                        BoxDecoration(
                          shape: BoxShape.circle,
                          color:Colors.grey,
                          // Jika _carouselCurrentIndex sama dengan index, gunakan warna biru; jika tidak, gunakan warna abu-abu
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )

            ],
          )
        ),
        SliverToBoxAdapter(
          child: Container(
            child: Column(

            ),
          ),
        ),
        /*SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(16),
            height: getScreenSize(context) == ScreenSize.small? 126 :
            getScreenSize(context) == ScreenSize.medium? 139  : 146,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                CategoryBtn(function: (){}, icon: Icons.border_all_rounded, name: 'Lihat Semua'),
                ...ProductCategory.values.map((e) => CategoryBtn(function: (){}, icon:  e.iconData, name: e.stringValue)).toList()
                ,//SizedBox(height: 8,)
              ],
            ),
          ),
        ),*/
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Koleksi Buku',
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: responsiveValue.extraTitleFontSize,
                          fontWeight: FontWeight.bold

                      ),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), // Bentuk rounded rectangle
                        color: Colors.indigoAccent.shade700, // Warna latar belakang dropdown header
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SortingType>(
                            value: preference.sortingType,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Icon dropdown
                            iconSize: 24.0,
                            elevation: 16,
                            dropdownColor: Colors.indigoAccent.shade700,
                            style: TextStyle(color: Colors.white, fontSize: responsiveValue.contentFontSize), // Warna teks dropdown header
                            onChanged: (SortingType? newValue) {
                              ref.read(preferenceProvider.notifier).updateStateWith(sortingType: newValue);
                            },
                            items: SortingType.values.map((SortingType sortingType) {
                              return DropdownMenuItem<SortingType>(
                                value: sortingType,
                                child: Text(sortingType.value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
                SizedBox(height: 8,),
                bookList.length != 0 ?GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: MediaQuery.of(context).size.width > 450 ||
                        MediaQuery.of(context).size.width < 285? 3/6 : 3/7 ,
                  ),
                  itemCount: bookList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // Tambahkan item-item Anda di sini
                    return BookCard(book: bookList.elementAt(index));
                  },
                ) : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
                    child: Center(
                      child:  Text('Tidak ada buku yang tersedia', style: TextStyle(
                          fontSize: responsiveValue.subtitleFontSize
                      ),),
                    )
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
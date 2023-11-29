import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/expandable_text.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/product_mini_image_container.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/review_widget.dart';
import 'package:proyek_akhir_semester/Homepage/api/like_book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/screens/search_page.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_card.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class ProductDetailPage extends ConsumerStatefulWidget{
  final int productId;
  ProductDetailPage({required this.productId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _ProductDetailPageState();
  }
}
class _ProductDetailPageState extends ConsumerState<ProductDetailPage>{
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final responsiveValue = ResponsiveValue();
  int _currentIndex = 0;
  CarouselController controller = CarouselController();
  bool _isColoredAppBar = false;

  @override
  Widget build(BuildContext context) {
    final productId = widget.productId;
    final auth = ref.watch(authProvider);
    final items = ref.watch(booksProvider);
    final pickItem = items[productId];
    final anotherItems = items.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => element.user.id == element.user.id && element.id != pickItem!.id ).toList();
    final anotherPickedItems = anotherItems.sublist(0, anotherItems.length < 6 ? anotherItems.length : 6);

    double _carouselHeight = getScreenSize(context) == ScreenSize.small ?250 :
    getScreenSize(context) == ScreenSize.medium ? 280 :300;

    
    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Scaffold(
      key: key,
      extendBodyBehindAppBar: true,
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 8), 
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(8)
                ),
                onPressed: (){},
                child: Text('Forum Diskusi', style: TextStyle(color: Colors.white, fontSize: responsiveValue.subtitleFontSize),),

              ),
              ),
              SizedBox(width: 8)
            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.metrics.axis == Axis.vertical) {
            // Hitung posisi scroll terkini
            final pixels = scrollNotification.metrics.pixels;

            // Cek apakah Carousel sudah terscroll keluar layar
            setState(() {
              _isColoredAppBar = pixels >= _carouselHeight;
            });
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CarouselSlider(
                      carouselController: controller,
                      options: CarouselOptions(
                          viewportFraction: 1,
                          height: getScreenSize(context) == ScreenSize.small ?250 :
                          getScreenSize(context) == ScreenSize.medium ? 280 :300 ,
                          onPageChanged: (index, reason){
                            setState(() {
                              _currentIndex = index;
                            });
                          }

                      ),
                      items: [
                        Container(
                              color: Colors.black,
                              child: Align(
                                  child: AspectRatio(
                                    aspectRatio: 4/4,
                                    child: Image.network(pickItem!.thumbnail, fit: BoxFit.cover,),
                                  )
                              )
                          ),
                        ...pickItem!.images.map((image){
                          return Container(
                              color: Colors.black,
                              child: Align(
                                  child: AspectRatio(
                                    aspectRatio: 4/4,
                                    child: Image.network(image, fit: BoxFit.cover,),
                                  )
                              )
                          );
                        }).toList()
                      ],
                    ),
                    Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.shade400,
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: Align(
                            child: Text('${pickItem!.saleability? 'For Sale' : 'Not For Sale'}',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        )),
                    Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent.shade400,
                            borderRadius: BorderRadius.circular(5),

                          ),
                          child: Align(
                            child: Text('${_currentIndex+1}/${pickItem.images.length +1}',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        ))
                  ],
                )
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${pickItem!.title}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsiveValue.titleFontSize,
                                  fontWeight: FontWeight.bold

                              ),

                            ),
                            SizedBox(height: 4,),
                            Text(pickItem!.price != null ?'Rp${pickItem!.price?.replaceAll(RegExp(r"(\.[0]*$)"), "")}':'FREE',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.indigoAccent.shade400,
                                fontSize: responsiveValue.extraTitleFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            ),
                          ],
                        )),
                        SizedBox(width: 8,),
                        IconButton(onPressed: (){
                          likeOrDislikeBook(auth, pickItem, context);
                        }, icon: Icon(Icons.favorite, color: auth == null? Colors.grey : pickItem!.likes.any((like) => like.userId == auth.id && like.likedBookId == pickItem!.id)? Colors.red : Colors.grey, size:
                        responsiveValue.titleFontSize + 12,))
                      ],
                    ),
                    SizedBox(height: 4,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Belum Terjual', style: TextStyle(
                            fontSize: responsiveValue.contentFontSize
                        ),),
                        SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.indigoAccent
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Align(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow,),
                                  Text('4.8', style: TextStyle(fontSize: responsiveValue.contentFontSize),),
                                  Text(' (105)', style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: responsiveValue.contentFontSize
                                  ),),

                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 8,),
                        
                      ],
                    ),
                    
                    SizedBox(height: 8,),
                    Text('Gambar', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    LayoutBuilder(builder: (context,constraint){
                      return Container(
                        height: 120,
                        width: constraint.maxWidth,
                        child: ProductMiniImageContainer(currIndex: _currentIndex, function: (index){
                          setState(() {
                            _currentIndex = index;
                          });
                          controller.animateToPage(index);
                        }, imagesData: [pickItem!.thumbnail,...pickItem!.images.cast<String>()])
                        ,
                      );
                    }),
                    SizedBox(height: 8,),
                    Text('Deskripsi', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    ExpandableDescription(text: pickItem!.description == null? 'Tidak ada deskripsi':pickItem!.description!.trim().isEmpty? 'Tidak ada deskripsi': pickItem!.description!
                    , maxLines: 5,),
                    SizedBox(height: 8,),
                    Text('Kategori', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 4,
                      runSpacing: 6,
                      children: [
                        ...pickItem!.categories.cast<String>().map((kategori){
                          return ElevatedButton(onPressed: (){}, child: Text('$kategori'));
                        }).toList()
                      ],
                    ),

                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Review', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: responsiveValue.titleFontSize),),
                        Text('Show All', textAlign: TextAlign.left, style: TextStyle(color: Colors.black,
                            fontSize: responsiveValue.subtitleFontSize),),
                      ],
                    ),
                    SizedBox(height: 4,),
                    ReviewsWidget(),
                    SizedBox(height: 8,),
                    Text('Penjual', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: responsiveValue.titleFontSize),),
                    SizedBox(height: 4,),
                    Container(
                      child: LayoutBuilder(
                        builder: (context, constraints){
                          return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.indigoAccent.shade400)
                              ),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:  MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.width > 300 ? responsiveValue.profilePictureSize : 40,
                                        backgroundImage: NetworkImage(
                                          pickItem!.user.profilePicture != null && !pickItem!.user.profilePicture!.isEmpty
                                              ? pickItem!.user!.profilePicture!
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
                                                  pickItem!.user.fullname!,
                                                  softWrap: false, // Tidak akan ada pemisahan baris
                                                  overflow: TextOverflow.ellipsis, // Teks yang tidak muat akan ditampilkan dengan ellipsis (...)
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.titleFontSize, // Ukuran nama lengkap
                                                    fontWeight: FontWeight.bold, // Gaya teks nama lengkap
                                                  ),
                                                ),
                                                SizedBox(height: 8), // Jarak antara nama lengkap dan username
                                                Text(
                                                  pickItem!.user.username!,
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.subtitleFontSize, // Ukuran username
                                                    fontWeight: FontWeight.normal,

                                                  ),
                                                  softWrap: false, // Tidak akan ada pemisahan baris
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4,),
                                                Text(
                                                  pickItem!.user.phoneNumber!,
                                                  style: TextStyle(
                                                    fontSize: responsiveValue.subtitleFontSize, // Ukuran email
                                                    fontWeight: FontWeight.normal,

                                                  ),
                                                  maxLines: 2, // Tidak akan ada pemisahan baris
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )),
                                      if(getScreenSize(context) != ScreenSize.small) Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue, // Warna latar belakang tombol
                                              padding: EdgeInsets.all(12), // Padding tombol
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                              ),
                                            ),
                                            child: Text(
                                              'Visit Profile',
                                              style: TextStyle(
                                                fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                                color: Colors.white, // Warna teks
                                                fontWeight: FontWeight.bold, // Gaya teks
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: responsiveValue.kDistance,),
                                        ],
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: responsiveValue.kDistance * 2),
                                  if(getScreenSize(context) == ScreenSize.small) Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Tambahkan aksi yang ingin dilakukan saat tombol ditekan
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue, // Warna latar belakang tombol
                                          padding: EdgeInsets.all(12), // Padding tombol
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                                          ),
                                        ),
                                        child: Text(
                                          'Visit Profile',
                                          style: TextStyle(
                                            fontSize: responsiveValue.subtitleFontSize, // Ukuran teks
                                            color: Colors.white, // Warna teks
                                            fontWeight: FontWeight.bold, // Gaya teks
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: responsiveValue.kDistance,),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  if(anotherPickedItems.length > 0) Divider(thickness: 1, color: Colors.indigoAccent,),
                                  if(anotherPickedItems.length > 0)Text('Produk lain dari penjual ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontSize: responsiveValue.subtitleFontSize),),
                                  if(anotherPickedItems.length > 0)SizedBox(height: 8,),
                                  if(anotherPickedItems.length > 0)LayoutBuilder(builder: (ctx, cs){
                                    return SizedBox(
                                      width: cs.maxWidth,
                                      height: (getScreenSize(context) == ScreenSize.small? 200 :
                                      getScreenSize(context)  == ScreenSize.medium? 220 : 240) *2 + 25,
                                      child: anotherPickedItems.length > 0 ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: anotherPickedItems.length ,
                                        itemBuilder: (BuildContext context, int index) {
                                          return SizedBox(
                                            width: getScreenSize(context) == ScreenSize.small? 200 :
                                            getScreenSize(context)  == ScreenSize.medium? 220 : 240,
                                            child: BookCard(book: anotherPickedItems[index]),
                                          );
                                        },
                                      ) : Center(
                                        child:
                                        Text('Tidak ada barang lain dari seller ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black,
                                            fontSize: responsiveValue.contentFontSize),),
                                      ),
                                    );
                                  })
                                ],
                              )
                          );
                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}
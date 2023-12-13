import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/Dashboard/screens/another_dashboard.dart';
import 'package:proyek_akhir_semester/DetailBook/screens/diskusi_page.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/expandable_text.dart';
import 'package:proyek_akhir_semester/DetailBook/widgets/product_mini_image_container.dart';
import 'package:proyek_akhir_semester/ReviewBook/screens/reviewbook_page.dart';
import 'package:proyek_akhir_semester/ReviewBook/widgets/review_widget_spill.dart';
import 'package:proyek_akhir_semester/Homepage/api/like_book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/book_card.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/models/responsive.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/screen/content_page.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/widgets/appbar.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';


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
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  final responsiveValue = ResponsiveValue();
  int _currentIndex = 0;
  CarouselController controller = CarouselController();
  bool _isColoredAppBar = false;

  Future<String> addComment(String text) async {
    final user =ref.watch(authProvider);
    if (user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda belum login')));
      return 'Unauthorized';
    }

    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anda tidak menulis apapun')));
      return 'Kosong';
    }

    final url = Uri.parse(BASE_URL+'/detail/add-comment-flutter/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        // Add other parameters as needed
        'user_id':user.id,
        'book_id':widget.productId,
        'content':text,
      }),
    );
    setState(() {
      text = '';
    });
    return 'Success';
  }

   void showForumDiskusi() {


      showModalBottomSheet(
        isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          context: context, builder: (context){
      //  TextEditingController controller = TextEditingController();
     
      // List<Comment> selectedComment = comments.where((element) => element.bookId == widget.productId).toList();
        return Diskusi(productId: widget.productId);
      });
   }


  @override
  Widget build(BuildContext context) {

    final productId = widget.productId;
    final auth = ref.watch(authProvider);
    final items = ref.watch(booksProvider);
    final pickItem = items[productId];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(pickItem == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maaf buku ini telah dihapus')));
        Navigator.of(context).pop();
      }
    });
    Map<int, Review> reviewMap= ref.watch(reviewListProvider);
    final reviewList = reviewMap.entries
        .map((entry) => entry.value)
        .toList().reversed.toList();
    final selectedReviewList = reviewList.where((review) => review.bookId==widget.productId).toList();
    final anotherItems = items.entries
        .map((entry) => entry.value)
        .toList().reversed.where((element) => element.user.id == pickItem!.user.id && element.id != pickItem!.id ).toList();
    final anotherPickedItems = anotherItems.sublist(0, anotherItems.length < 6 ? anotherItems.length : 6);

    double carouselHeight = getScreenSize(context) == ScreenSize.small ?250 :
    getScreenSize(context) == ScreenSize.medium ? 280 :300;

   

    responsiveValue.setResponsive(context);
    // TODO: implement build
    return Scaffold(
      key: key1,
      drawer: MyDrawer(callBack: (identifier){

      },),
      appBar: MyAppBar(scaffoldKey: key1, title: 'Book Details',),
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
                onPressed: (){
                  showForumDiskusi();
                },
                child: Text('Forum Diskusi', style: TextStyle(color: Colors.white, fontSize: responsiveValue.subtitleFontSize),),

              ),
              ),
              SizedBox(width: 8)
            ],
          ),
        ),
      ),
      body: CustomScrollView(
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
                          Text(pickItem!.price != null && pickItem.price!.isNotEmpty ?'Rp${pickItem!.price?.replaceAll(RegExp(r"(\.[0]*$)"), "")}':'FREE',
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

                      selectedReviewList.length > 0 ?Container(
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
                                Text(pickItem!.calculateAverageStars().toStringAsFixed(1), style: TextStyle(fontSize: responsiveValue.contentFontSize),),
                                Text(' (${selectedReviewList.length})', style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: responsiveValue.contentFontSize
                                ),),

                              ],
                            )
                        ),
                      ): Text('Belum ada review', style: TextStyle(color: Colors.black, fontSize: responsiveValue.contentFontSize),),
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
                  
                  SizedBox(height: 4,),
                  Text('Deskripsi', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(text: pickItem!.description == null? 'Tidak ada deskripsi'
                      :pickItem!.description!.trim().isEmpty? 'Tidak ada deskripsi': pickItem!.description!
                    , maxLines: 5,),
                  SizedBox(height: 4,),
                  Text('Maturity Rating', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(text: pickItem!.maturityRating == 'MATURE'? 'Dewasa': 'Semua Umur'
                    , maxLines: 5,),
                  SizedBox(height: 4,),
                  Text('Author', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(
                    text: pickItem!.authors == null || pickItem.authors.isEmpty
                      ? '-'
                      : pickItem!.authors is String
                        ? pickItem!.authors as String
                        : (pickItem!.authors as List<dynamic>).join(', '),
                    maxLines: 5,
                  ),

                  SizedBox(height: 8,),
                  Text('Kategori', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),

                  SizedBox(height: 4,),
                  ExpandableDescription(
                    text: pickItem!.categories == null || pickItem!.categories!.isEmpty
                      ? '-'
                      : pickItem!.categories is String
                        ? pickItem!.categories as String
                        : (pickItem!.categories as List<dynamic>).join(', '),
                    maxLines: 5,
                  ),
          
                  SizedBox(height: 4,),
                  Text('Publisher', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(text: pickItem!.publisher == null? '-':pickItem!.publisher!.trim().isEmpty? 'Tidak ada publisher': pickItem!.publisher!
                    , maxLines: 5,),

                  SizedBox(height: 4,),
                  Text('Language', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(text: pickItem!.language == null? '-':pickItem!.language!.trim().isEmpty? 'Tidak ada language': pickItem!.language!
                    , maxLines: 5,),

                  SizedBox(height: 4,),
                  Text('Pages', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(
                    text: pickItem!.pageCount == null
                      ? '-'
                      : pickItem!.pageCount.toString(),
                    maxLines: 5,
                  ),

                  SizedBox(height: 4,),
                  Text('Published Date', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: responsiveValue.titleFontSize),),
                  SizedBox(height: 4,),
                  ExpandableDescription(text: pickItem!.publishedDate == null? '-':pickItem!.publishedDate!.trim().isEmpty? 'Tidak ada published date': pickItem!.publishedDate!
                    , maxLines: 5,),

                  if(pickItem.pdfAvailable || pickItem.epubAvailable ||
                      (pickItem.buyLink != null && pickItem.buyLink!.isNotEmpty))Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4,),
                      Text('Link Buku', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: responsiveValue.titleFontSize),),
                      SizedBox(height: 4,),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (  pickItem!.saleability  && pickItem.buyLink != null && pickItem!.buyLink!.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                launchPdfLink(pickItem!.buyLink!);
                              },

                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade400,
                                  padding: EdgeInsets.all(16)
                              ),
                              child: Text(
                                'Beli Buku',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveValue.titleFontSize,
                                ),
                              ),
                            ),
                          if ( pickItem!.pdfAvailable && pickItem!.pdfLink != null && pickItem!.pdfLink!.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                launchPdfLink(pickItem!.pdfLink!);
                              },

                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigoAccent.shade400,
                                  padding: EdgeInsets.all(16)
                              ),
                              child: Text(
                                'PDF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveValue.titleFontSize,
                                ),
                              ),
                            ),
                          if (pickItem!.epubAvailable && pickItem!.epubLink != null && pickItem!.epubLink!.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                launchPdfLink(pickItem!.epubLink!);
                              },

                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.all(16)
                              ),
                              child: Text(
                                'EPUB',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsiveValue.titleFontSize,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Review', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: responsiveValue.titleFontSize),),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return DaftarReview(bookId: widget.productId);
                          }));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Show All',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: responsiveValue.subtitleFontSize,
                          ),
                        ),
                      ),

                    ],
                  ),
    
                  SizedBox(height: 4,),
                  ReviewsWidget(reviews: selectedReviewList, bookId: widget.productId),
                  SizedBox(height: 8,),
                  Text('User', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
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
                                            if(auth != null && pickItem!.user.id == auth.id ){
                                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                 return ContentPage(currentIndex: 2,);
                                               }));
                                            }
                                            else{
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                                return AnotherDashboard(user: pickItem!.user);
                                              }));
                                            }
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
                                        if(auth != null && pickItem!.user.id == auth.id ){
                                          print('hello');
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                        return ContentPage(currentIndex: 2,);
                                        }));
                                        }
                                        else{
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                            return AnotherDashboard(user: pickItem!.user);
                                          }));
                                        }
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
                                if(anotherPickedItems.length > 0)Text('Buku lain dari user ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
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
                                      Text('Tidak ada buku lain dari user ini', textAlign: TextAlign.left, style: TextStyle(color: Colors.black,
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
    );
  }
  
  void launchPdfLink(String pdfLink) async {
      if (await canLaunch(pdfLink)) {
        await launch(pdfLink);
      } else {
        throw 'Could not launch $pdfLink';
      }
  }
}
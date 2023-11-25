import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/love_button.dart';
import 'package:proyek_akhir_semester/Homepage/widgets/rating.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';

import '../models/book.dart';
import '../../models/responsive.dart';
import '../../util/responsive_config.dart';
import '../../util/time.dart';
import 'package:proyek_akhir_semester/Homepage/api/like_book.dart';
class BookCard extends ConsumerWidget {
  final Book book;
  BookCard({super.key,
    required this.book,
  });
  double titleFontSize = TextSize.BASE.fontSize;
  double subtitleFontSize = TextSize.SM.fontSize;
  double contentFontSize = TextSize.XS.fontSize;
  double profilePictureSize = 30;
  double appBarHeight = 200;
  double kDistance = 12;
  double profileDistance = 20;

  void setResponsive(context){
    final screenSize = getScreenSize(context);
    if(screenSize == ScreenSize.small){
      titleFontSize = TextSize.BASE.fontSize;
      subtitleFontSize = TextSize.SM.fontSize;
      contentFontSize = TextSize.XS.fontSize;
      profilePictureSize = 70;
      appBarHeight = 300;
      kDistance = 12;
      profileDistance = 20;
    }
    else if(screenSize == ScreenSize.medium){
      titleFontSize = TextSize.MD.fontSize;
      subtitleFontSize = TextSize.BASE.fontSize;
      contentFontSize = TextSize.SM.fontSize;
      profilePictureSize = 90;
      appBarHeight = 280;
      kDistance = 16;
      profileDistance = 40;
    }
    else{
      titleFontSize = TextSize.LG.fontSize;
      subtitleFontSize = TextSize.MD.fontSize;
      contentFontSize = TextSize.BASE.fontSize;
      profilePictureSize = 100;
      appBarHeight = 340;
      kDistance = 20;
      profileDistance = 60;
    }
  }

  String generateAuthors(List<String> authors){
    if(authors.isEmpty){
      return 'Author tidak diketahui';
    }
    if(authors.length == 1){
      return authors[0];
    }
    if(authors.length == 2){
      return '${authors[0]} dan ${authors[1]}';
    }
    String authorstr = authors[0];
    for(int i = 1; i < authors.length ; i++){
      if(i == authors.length - 1){
        authorstr += ',dan ${authorstr[i]}';
      }
      else {
        authorstr += ', ${authors[i]}';
      }
    }
    return authorstr;

  }
  String generateCategories (List<String> categories){
    if(categories.isEmpty){
      return "Tidak ada kategori";
    }
    String categoryStr = categories[0];
    for(int i = 1; i < categories.length; i++){
      categoryStr += ', ${categories[i]}';
    }
    return categoryStr;
  }


  
  @override
  Widget build(BuildContext context, ref) {
    var user = ref.watch(authProvider);
    setResponsive(context);
    return Card(
      color: Colors.white70,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:GestureDetector(
        onTap: (){
          //todo: navigasi
          /*Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return ProductDetailPage(productId: shopItem.itemId,);
          }));*/
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.98,
                  child: Image.network(
                    //'$BASE_URL/proxy/${book.thumbnail.replaceFirst(RegExp(r'https?://'), '')}',
                    book.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Builder(builder:(context){
                      final isLiked = user == null? false : book.likes.any((like) => like.userId == user.id && like.likedBookId == book.id);
                      return LoveButton(isLiked: isLiked, loveCount: book.likes.length, onPressed: (){
                        likeOrDislikeBook(user, book, context);
                      });
                    }), ),

              ],
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: getScreenSize(context) == ScreenSize.small? 1 : 2,
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(book.user.profilePicture != null? book.user.profilePicture!.isNotEmpty?
                              book.user.profilePicture!:  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png':
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                              radius: subtitleFontSize, // Sesuaikan dengan ukuran yang Anda inginkan
                            ),
                            const SizedBox(width: 8), // Beri jarak antara gambar profil dan teks
                            Flexible(
                              child: Text(
                                user == null? book.user.fullname : user!.id == book.user.id? 'Anda' : book.user.fullname,
                                maxLines: getScreenSize(context) == ScreenSize.small?1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),

                          ],

                        ),
                        Padding(
                  padding: const EdgeInsets.only(right: 8, top: 8),
                  child: Text(generateAuthors(book.authors), maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(
                    fontSize: contentFontSize,
                    color: Colors.grey.shade700,
                  ),),
                ),
                        Row(
                          children: [

                            Padding(
                              padding: const EdgeInsets.only( top: 8),
                              child: book.reviews.isEmpty? Text(

                                'Belum ada ulasan', //todo:
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                  color: Colors.grey.shade700,
                                ),
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StarRating(book.calculateAverageStars()),
                                  SizedBox(width: 8,),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(book.calculateAverageStars().toStringAsFixed(1), style: TextStyle(
                                          fontSize: contentFontSize
                                      ),),
                                      SizedBox(width: 4,),
                                      Text('(${book.reviews.length})', style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: contentFontSize
                                      ),)
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(child: Text(generateCategories(book.categories), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: contentFontSize, color: Colors.grey.shade700) ))
                          ],
                        )
                      ],

                    ),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(

                          book.saleability && book.price != null? 'Rp ${book.price}' : 'Free',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.indigoAccent.shade400,
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),),
                      SizedBox(height: 4,),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),
                              Text(

                                formatTimeAgo(book.userPublishTime),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: contentFontSize,
                                ),
                              )
                            ],
                          ))
                    ],
                  )
                ],
              ),
            ))

          ],
        ),
      ),
    );

  }
}
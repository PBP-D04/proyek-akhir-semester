import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';
import 'package:proyek_akhir_semester/DetailBook/provider/comment_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/ReviewBook/provider/review_provider.dart';
import 'package:proyek_akhir_semester/models/review.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../Homepage/models/book.dart';
import '../models/user.dart';


/* PENTING:
* layanan Pusher untuk realtime update di semua device yang terkoneksikan dengan app Bookphoria.
*  Jadi kalo misal buat chat atau review , kita ga perlu melakukan refresh terhadap aplikasi Flutter
* */

Future<void> initPusher(context, WidgetRef ref) async {
  try{
    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    await pusher.init(apiKey: '7b3be760fa27ea1935c8', cluster: 'ap1', onEvent: (event) async{
      onEvent(event, context, ref);
    });
    await pusher.subscribe(channelName: 'bookphoria');
    await pusher.connect();
  }
  catch(err){
    print(err);
  }
}

Future<void> onEvent(PusherEvent event, context, WidgetRef ref) async{
  if(event.channelName == 'bookphoria'){ // Nama Channel


    switch (event.eventName) {
      case 'update-profile':
        final data = event.data;
        print('cek');
        dynamic decodedData = jsonDecode(jsonEncode(data));
        if(decodedData.runtimeType == String){
          decodedData = jsonDecode(decodedData);
        }
        var message = decodedData['message'];
        if(message.runtimeType == String){
          message = jsonDecode(message);
        }
        int userId = message['id'];
        User updatedUser = User.fromJson(message);
        Map<int, Book> books = ref.watch(booksProvider);
        books.updateAll((key, value){
          if(value.user.id == userId){
            value.user = updatedUser;
          }
          return value;
        });

        Map<int, Review>reviews = ref.watch(reviewListProvider);
        reviews.updateAll((key, value) {
          if(value.user.id == userId){
            value.user = updatedUser;
          }
          return value;
        });
        List<Comment> comments = ref.watch(commentNotifierProvider);
        comments.forEach((element) {
          element.profilePicture = updatedUser.profilePicture;
        });
          final currUser = ref.watch(authProvider);
          if(currUser != null){
            if(currUser.id == userId){
              ref.read(authProvider.notifier).setUserData(updatedUser);
            }
          }
          ref.read(commentNotifierProvider.notifier).state = [...comments];
          ref.read(booksProvider.notifier).setItems({...books});
          ref.read(reviewListProvider.notifier).setAll({...reviews});
        break;




      case 'new-book':
        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data));
        if(decodedData.runtimeType == String){
          decodedData = jsonDecode(decodedData);
        }
        final Map<int,Book> booksMap = ref.watch(booksProvider);
        var message = decodedData['message'];
        if(message.runtimeType == String){
          message = jsonDecode(message);
        }
        User user = User.fromJson(message['user']);
        // print(user);
        Book book = Book.fromJson(message['book'], user);
        //print(book);
        for (var dataReview in message['review']) {
          // print('HERE');
          Review review = Review.fromJson(dataReview);
          book.reviews.add(review);
        }
        booksMap[book.id] = book;
        ref.read(booksProvider.notifier).addItem(book);
        break;
      case 'delete-review':
        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data));
        print(decodedData);
        print('--------------------------------');
        if(decodedData.runtimeType == String){
          decodedData = jsonDecode(decodedData);
        }

        final message = decodedData['message'];
        final reviewId = message;
        Review? review = ref.watch(reviewListProvider)[reviewId];
        ref.read(reviewListProvider.notifier).removeReview(message);
        if(review != null){
          Book? book = ref.watch(booksProvider)[review.bookId];
          if(book != null){
            book.reviews.removeWhere((element) => element.id == reviewId);
            ref.read(booksProvider.notifier).updateItem(book.id, book);
          }
        }
        break;
      case 'new-review':
        print('cok cok');
        print('ayo dong deck');
        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data));
        if(decodedData.runtimeType == String){
          decodedData = jsonDecode(decodedData);
        }
        final message = decodedData['message'];
        print(message);
        Review review = Review.fromJson(message);
        ref.read(reviewListProvider.notifier).addOrUpdateReview(review);
        Book? book = ref.watch(booksProvider)[review.bookId];
        if(book != null){
          book.reviews.removeWhere((element) => element.id == review.id);
          book.reviews.add(review);
          ref.read(booksProvider.notifier).updateItem(book.id, book);
        }
        break;
     case 'like-book':

        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data)); //Mengatasi LinkedMap kalo di PC biar jadi Map<String, dynamic>
        print('--------------------------------------');
        print(decodedData.runtimeType);
        if(decodedData.runtimeType == String){ // Kalo di mobile ko bedaaa? Mengatasi hasil decode masih String
          decodedData = jsonDecode(decodedData);
        }
        print('------------------------------------');
        final message = jsonDecode(decodedData['message']); // ini dari json dumps di django pasti String
        final isLiked = message['is_liked'];
        final userId = message['user_id'];
        final bookId = message['book_id'];
        ref.read(booksProvider.notifier).updateLikeStatus(bookId, isLiked, userId);
         // Update Book
        break;


      case 'new-comment':
        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data));
        if(decodedData.runtimeType == String){ // Kalo di mobile ko bedaaa? Mengatasi hasil decode masih String
          decodedData = jsonDecode(decodedData);
        } //Mengatasi LinkedMap kalo di PC biar jadi Map<String, dynamic>
        print('--------------------------------------');
        Comment comment = Comment.fromJson(decodedData['message']);
        ref.read(commentNotifierProvider.notifier).addComment(comment);
        break;

      case 'delete-book':
        final data = event.data;
        dynamic decodedData = jsonDecode(jsonEncode(data));
        if(decodedData.runtimeType == String){ // Kalo di mobile ko bedaaa? Mengatasi hasil decode masih String
          decodedData = jsonDecode(decodedData);
        }
        Map<int,Book> books = ref.watch(booksProvider);
        decodedData['message'].forEach((index){
          books.remove(index);
        });
        ref.read(booksProvider.notifier).setItems(books);
        break;
      default:
        break;
    }

  }
}


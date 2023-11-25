import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';


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
    if(event.data.runtimeType == String){
     // print('antum string?');
    }
   // print('apa sihhh..');


    switch (event.eventName) {
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
      default:
        break;
    }

  }
}


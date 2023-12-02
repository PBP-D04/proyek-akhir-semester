
import 'package:proyek_akhir_semester/DetailBook/Models/comment.dart';

import '../../Homepage/models/history.dart';
import '../../models/review.dart';
import '../../models/user.dart';

class CurrentActivity {
  final dynamic data;
  final User user;
  late final DateTime time;

  CurrentActivity({required this.data, required this.user}) {
    if (data.runtimeType == Review) {
      Review reviewData = data;
      time = reviewData.dateAdded;
    } else if (data.runtimeType == History) {
      History historyData = data;
      time = historyData.time;
    } else if( data.runtimeType == Comment){
      Comment comment = data;
      time = comment.createdAt;
    }
    else {
      // Default value or handling for other types
      time = DateTime.now(); // Contoh: Defaultnya DateTime.now()
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/util/time.dart';

class CommentItem extends ConsumerWidget {
  final String username;
  final String reviewText;
  final String? profileImage;
  final int userId;
  DateTime createdAt;

  ResponsiveValue responsiveValue = ResponsiveValue();

  CommentItem({
    required this.userId,
    required this.createdAt,
    required this.username,
    required this.reviewText,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(authProvider);
    responsiveValue.setResponsive(context);
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: user != null && user.id == userId? Colors.green.shade100 : Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage == null? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png': profileImage!.trim().isEmpty? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png': profileImage!),
                radius: 20.0,
              ),
              SizedBox(width: 12.0),
              Text(
                user  == null? username : user.id == userId ? 'Anda' : username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8.0),
        
          Text(reviewText, style: TextStyle(color: Colors.black, fontSize: responsiveValue.contentFontSize + 4 ),),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(formatTimeAgoDate(createdAt), style: TextStyle(color: Colors.grey.shade600, fontSize: responsiveValue.contentFontSize ),),
            ],
          ),
          SizedBox(height: 8,)
        ],
      ),
    );
  }
}
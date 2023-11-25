import 'package:flutter/material.dart';
class LoveButton extends StatelessWidget {
  final bool isLiked;
  final int loveCount;
  final VoidCallback onPressed;

  LoveButton({
    required this.isLiked,
    required this.loveCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: isLiked ? Colors.red : Colors.grey[200],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.white : Colors.grey,
                ),
                SizedBox(width: 4.0),
                Text(
                  '$loveCount',
                  style: TextStyle(
                    color: isLiked ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

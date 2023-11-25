import 'package:flutter/material.dart';

import '../../util/responsive_config.dart';
class StarRating extends StatelessWidget {
  final double starCount;
  ResponsiveValue resVal = ResponsiveValue();
  StarRating(this.starCount);

  @override
  Widget build(BuildContext context) {
    resVal.setResponsive(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < starCount.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: resVal.titleFontSize,
        );
      }),
    );
  }
}
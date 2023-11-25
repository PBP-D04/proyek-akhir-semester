import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class StarsRadioButtons extends StatelessWidget {
  final int maxStars = 5;
  final List<String> averageRatingOptions;
  final String currentSelected;
  final Function(String) callBack;
  ResponsiveValue responsiveValue = ResponsiveValue();

  StarsRadioButtons({
    required this.averageRatingOptions,
    required this.currentSelected,
    required this.callBack,
  });

  Widget _buildStars(String starCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxStars,
            (index) => Icon(
          index < int.parse(starCount) ? Icons.star : Icons.star_border,
          color: Colors.orange,
              size: responsiveValue.contentFontSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    responsiveValue.setResponsive(context);
    return Wrap(
      runSpacing: 4,
      spacing: 4,
      children: averageRatingOptions.map((option) {
        return GestureDetector(
          onTap: () {
            callBack(option);
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: currentSelected == option ? Colors.blue : Colors.white,
              border: Border.all(
                color: currentSelected == option ? Colors.blue : Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(option != 'Default')_buildStars(option),
                if(option != 'Default')SizedBox(width: 8),
                if(option != 'Default')Text(
                  '& up',
                  style: TextStyle(fontSize: responsiveValue.contentFontSize,
                      color:currentSelected == option ? Colors.white : Colors.black), // Sesuaikan dengan ukuran teks yang diinginkan
                ),
                if(option == 'Default')Text(
                  'Default',
                  style: TextStyle(fontSize: responsiveValue.contentFontSize
                  ,color: currentSelected == option ? Colors.white : Colors.black), // Sesuaikan dengan ukuran teks yang diinginkan
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

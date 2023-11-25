import 'package:flutter/material.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';

class RadioButtons extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onChanged;
  ResponsiveValue responsiveValue = ResponsiveValue();

  RadioButtons({
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    responsiveValue.setResponsive(context);
    return Wrap(
      spacing: 8.0, // Spasi antara widget
      runSpacing: 8.0, // Spasi antara baris
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: option,
              groupValue: selectedOption,
              onChanged: (value) {
                print('NAPA SIHHH');
                onChanged(value!);
              },
            ),
            Text(option, style: TextStyle(fontSize: responsiveValue.contentFontSize),),
          ],
        );
      }).toList(),
    );
  }
}

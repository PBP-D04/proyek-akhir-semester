import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YearRangeInput extends StatelessWidget {
  final TextEditingController minYearController;
  final TextEditingController maxYearController;
  final Function(String, String) onYearChanged;

  YearRangeInput({
    required this.minYearController,
    required this.maxYearController,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: TextField(
            controller: minYearController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,

            ],
            decoration: InputDecoration(
              labelText: 'Min Year',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(fontSize: 16.0),
            onChanged: (value) {
              onYearChanged(value, maxYearController.text);
            },
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: TextField(
            controller: maxYearController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,

            ],
            decoration: InputDecoration(
              labelText: 'Max Year',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(fontSize: 16.0),
            onChanged: (value) {
              onYearChanged(minYearController.text, value);
            },
          ),
        ),
      ],
    );
  }
}

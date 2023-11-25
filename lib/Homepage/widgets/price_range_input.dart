import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceRangeInput extends StatelessWidget {
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final Function(String, String) onPriceChanged;

  PriceRangeInput({
    required this.minPriceController,
    required this.maxPriceController,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: TextField(
            controller: minPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'Min Price',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(fontSize: 16.0),
            onChanged: (value) {
              onPriceChanged(value, maxPriceController.text);
            },
          ),
        ),
        SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: TextField(
            controller: maxPriceController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'Max Price',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
              labelStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(fontSize: 16.0),
            onChanged: (value) {
              onPriceChanged(minPriceController.text, value);
            },
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime currentDate;
  final Function(DateTime) onSubmitDate;

  DatePickerWidget({
    required this.currentDate,
    required this.onSubmitDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Ganti warna primary sesuai keinginan Anda
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != currentDate) {
      onSubmitDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Tanggal Terbit Buku',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${currentDate.toLocal()}'.split(' ')[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Ganti warna teks sesuai keinginan Anda
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Book Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReviewBookPage(),
    );
  }
}

class ReviewBookPage extends StatefulWidget {
  @override
  _ReviewBookPageState createState() => _ReviewBookPageState();
}

class _ReviewBookPageState extends State<ReviewBookPage> {
  int _rating = 0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan Buku'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Rating:', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            Text('Komentar:', style: TextStyle(fontSize: 18)),
            TextField(
              onChanged: (value) {
                _comment = value;
              },
              decoration: InputDecoration(
                hintText: 'Tulis komentar Anda di sini',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_rating == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Mohon berikan rating bintang'),
                  ));
                  return;
                }
                // Kirim data ulasan
              },
              child: Text('Kirim Ulasan'),
            ),
          ],
        ),
      ),
    );
  }
}

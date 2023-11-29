import 'package:flutter/material.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({super.key});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _starRating = 0;
  String _comment = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Form Ulasan'),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      // drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Bintang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _starRating,
                  items: List.generate(5, (index) => index + 1)
                      .map<DropdownMenuItem<int>>(
                          (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text('$value Bintang'),
                              ))
                      .toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _starRating = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == 0) {
                      return 'Mohon pilih jumlah bintang';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Tulis komentar Anda di sini...",
                    labelText: "Komentar (Opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _comment = value ?? '';
                    });
                  },
                  maxLines: 3,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simpan data ulasan
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Ulasan berhasil tersimpan'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Bintang: $_starRating'),
                                    Text('Komentar: $_comment'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Simpan Ulasan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
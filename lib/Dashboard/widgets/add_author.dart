import 'package:flutter/material.dart';

class AddAuthorScreen extends StatelessWidget {
  final List<String> authors;
  final Function(String) onAddAuthor;
  final Function(int) onRemoveAuthor;

  AddAuthorScreen({
    required this.authors,
    required this.onAddAuthor,
    required this.onRemoveAuthor,
  });

  TextEditingController authorController = TextEditingController();

  void addAuthor(String authorName) {
    onAddAuthor(authorName);
    authorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Nama Author'),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  String authorName = authorController.text;
                  if (authorName.isNotEmpty) {
                    addAuthor(authorName);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Peringatan'),
                          content: Text('Nama Author tidak boleh kosong!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Tambah'),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (authors.isNotEmpty)
            Text(
              'List Author:',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          SizedBox(height: 10),
          ListView.builder(
            itemCount: authors.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(authors[index], style: TextStyle(color: Colors.black)),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onRemoveAuthor(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

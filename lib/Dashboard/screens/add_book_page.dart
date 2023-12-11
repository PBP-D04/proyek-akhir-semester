import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Dashboard/api/submitBook.dart';
import 'package:proyek_akhir_semester/Dashboard/widgets/add_author.dart';
import 'package:proyek_akhir_semester/Dashboard/widgets/add_date.dart';
import 'package:proyek_akhir_semester/Homepage/models/book.dart';
import 'package:proyek_akhir_semester/Homepage/provider/books_provider.dart';
import 'package:proyek_akhir_semester/Homepage/provider/categories_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/api/cloudinary._api.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/download_file.dart';

import '../../widgets/drawer.dart';
import '../widgets/dash--mini_image_container.dart';


class AddBookPage extends ConsumerStatefulWidget{
  int? bookId;
  AddBookPage({super.key, this.bookId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddBookPageState();
  }
}
class _AddBookPageState extends ConsumerState<AddBookPage>{

  // CLEAR
  List<Uint8List> productsImage = [];
  Map<String, Map<String,dynamic>> productCategories = {};
  bool isEdit = false;
  Map<String, Map<String,dynamic>> mapProductCategories() {
    final categories = ref.watch(categoriesProvider);
    final data = categories.categories.map((category) => {
      'enumValue':category,
      'stringValue':category,
      'isSelected': false
    }).toList().sublist(1);
    return Map.fromIterable(data,key: (item) => item['enumValue'] as String, // Menggunakan enumValue sebagai kunci Map
        value: (item) => item as Map<String, dynamic>);
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> authors = [];

  final TextEditingController publisherController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController currencyCodeController = TextEditingController();
  final TextEditingController pdfLinkController = TextEditingController();
  final TextEditingController buyLinkController = TextEditingController();
  final TextEditingController epubLinkController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();
  DateTime publishedDate = DateTime.now();
  bool isForSale = false;
  bool isMature = false;
  bool isEbook = false;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        productCategories = mapProductCategories();
      });
      initEdit();
    });
  }

  Future<void> initEdit() async{
    print('sasukeeeeeeeeeeeeeeee..............');
    print(widget.bookId);
    if(widget.bookId != null){
      print('Holy Molly');
      Book? book =ref.watch(booksProvider)[widget.bookId!];
      if(book == null){
        return;
      }
      print('chidoriiiiii!!!!!!');
      final newProductCategories = {...productCategories};
      for(var category in book.categories){
        if(newProductCategories[category] != null){
          newProductCategories[category]!['isSelected'] = true;
        }
      }
      setState(() {
        productCategories = newProductCategories;
        isEdit = true;
        titleController.text = book.title;
        subtitleController.text = book.subtitle??'';
        descriptionController.text = book.description??'';
        authors = book.authors;
      publisherController.text = book.publisher??'';
     priceController.text = book.price??'';
       languageController.text = book.language??'';
        currencyCodeController.text = book.currencyCode??'';
      pdfLinkController.text = book.pdfLink??'';
         buyLinkController.text = book.buyLink??'';
       epubLinkController.text = book.epubLink??'';
        pageCountController.text = book.pageCount.toString();
        isForSale = book.saleability;
        isMature = book.maturityRating.toUpperCase()=='MATURE'? true : false;
        isEbook = book.isEbook;
      });
      List<Uint8List> imgsByte = [];
      for(var imgurl in [book.thumbnail,...book.images]){
        XFile? data = await xFileFromImageUrl(imgurl);
        if(data != null){
          Uint8List byte = await data.readAsBytes();
          imgsByte.add(byte);
        }
      }
      setState(() {
        productsImage = imgsByte;
      });

    }
  }

  Future<void> onSubmit() async {
    final user = ref.watch(authProvider);
    List<Map<String,dynamic>> selectedCategoryData = productCategories.values.where((element) => element['isSelected'] == true).toList();
    List<String> category = selectedCategoryData.map((e) => e['stringValue'].toString()).toList();
    if(category.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maaf minimal harus ada satu kategori yang terpilih'), backgroundColor: Colors.red,));
      return;
    }

    if(productsImage.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maaf minimal harus ada satu gambar yang terpilih'), backgroundColor: Colors.red,));
      return;
    }
    if(titleController.text.trim().isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maaf judul tidak boleh kosong'), backgroundColor: Colors.red,));
      return;
    }
    List<String> imageUrls = [];
    for(final byte in productsImage){
      var url = await uploadImageToCloudinaryPublicFromByteData(byte);
      imageUrls.add(url??'');
    }
    Book book = Book(likes: [], user: user!, id: -1,subtitle: subtitleController.text.trim().isNotEmpty? subtitleController.text : null, description: descriptionController.text.trim(),title: titleController.text, currencyCode: currencyCodeController.text,
        authors: authors, publisher: publisherController.text, publishedDate: publishedDate.toIso8601String(),
        language: languageController.text, isEbook: isEbook, pdfAvailable: pdfLinkController.text.trim().isNotEmpty,
        pdfLink: pdfLinkController.text, buyLink: this.isForSale && buyLinkController.text.trim().isNotEmpty? buyLinkController.text : null,
        thumbnail: imageUrls[0], categories: category, images: imageUrls.sublist(1), price: priceController.text,
        saleability: this.isForSale, epubAvailable: epubLinkController.text.trim().isNotEmpty,epubLink: epubLinkController.text, maturityRating: this.isMature? 'MATURE' : 'NOT_MATURE', pageCount:
        pageCountController.text.trim().isNotEmpty? int.parse(pageCountController.text) : 1,
        userPublishTime: DateTime.now().toIso8601String(), reviews: []);
    final res = await submitBook(book, this.isEdit, widget.bookId??-1);
    if(res == 'SUCCESS'){
      Navigator.of(context).pop();
    }
  }
  // CLEAR
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
   // authorsController.dispose();
    publisherController.dispose();
 //   publishedDateController.dispose();
    languageController.dispose();
    currencyCodeController.dispose();
   // thumbnailController.dispose();
    pdfLinkController.dispose();
    buyLinkController.dispose();
    epubLinkController.dispose();
    priceController.dispose();
    pageCountController.dispose();
   // maturityRatingController.dispose();
    //userPublishTimeController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: !isEdit?Text('Tambah Buku', style: TextStyle(color: Colors.indigoAccent.shade700, fontWeight: FontWeight.bold),):Text('Edit Buku', style: TextStyle(color: Colors.indigoAccent.shade700, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black), // Atur warna ikon hamburger
              onPressed: () {
                Navigator.of(context).pop(); // Tindakan ketika hamburger diklik
              },
            );
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: Colors.black), // Atur warna ikon hamburger
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Tindakan ketika hamburger diklik
                },
              );
            },
          ),
        ],
      ),
      drawer: MyDrawer(callBack: (String identifier) {

      },),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Judul Buku',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Judul Buku tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: subtitleController,
                          decoration: InputDecoration(
                            labelText: 'Subjudul Buku',
                          ),
                          // ... (validator, dsb.)
                        ),
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Deskripsi Buku',
                          ),
                          // ... (validator, dsb.)
                        ),

                        DatePickerWidget(currentDate: publishedDate , onSubmitDate: (date){
                          setState(() {
                            publishedDate = date;
                          });
                        }),
                        AddAuthorScreen(authors: authors, onAddAuthor: (author){
                          setState(() {
                            authors.add(author);
                          });
                        }, onRemoveAuthor: (index){
                          setState(() {
                            authors.removeAt(index);
                          });
                        },),
                        TextFormField(
                          controller: publisherController,
                          decoration: InputDecoration(
                            labelText: 'Penerbit Buku',
                          ),
                          // ... (validator, dsb.)
                        ),
                        TextFormField(
                          controller: languageController,
                          decoration: InputDecoration(
                            labelText: 'Bahasa Buku',
                          ),
                          // ... (validator, dsb.)
                        ),


                        TextFormField(
                          controller: pdfLinkController,
                          decoration: InputDecoration(
                            labelText: 'Link PDF Buku',
                          ),
                          // ... (validator, dsb.)
                        ),
                        TextFormField(
                          controller: buyLinkController,
                          decoration: InputDecoration(
                            labelText: 'Link Pembelian Buku',
                          ),
                          // ... (validator, dsb.)
                        ),
                        TextFormField(
                          controller: epubLinkController,
                          decoration: InputDecoration(
                            labelText: 'Link EPUB Buku',
                          ),
                          // ... (validator, dsb.)
                        ),
                        SizedBox(height: 8,),
                        LayoutBuilder(builder: (context, constraints){
                          return Container(
                            width: constraints.maxWidth,
                            child: Wrap(

                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Apakah buku ini termasuk ebook?', style:TextStyle(color: Colors.grey)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.isEbook = true;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: this.isEbook ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Ya',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.isEbook = false;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: !this.isEbook ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Tidak',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],

                            ),
                          );
                        }),
                        SizedBox(height: 8,),
                        LayoutBuilder(builder: (context, constraints){
                          return Container(
                            width: constraints.maxWidth,
                            child: Wrap(

                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Apakah buku ini ramah anak?', style:TextStyle(color: Colors.grey)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.isMature = false;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: !this.isMature ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Ya',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this.isMature = true;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: this.isMature ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Tidak',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],

                            ),
                          );
                        }),
                        SizedBox(height: 8,),
                        LayoutBuilder(builder: (context, constraints){
                          return Container(
                            width: constraints.maxWidth,
                            child: Wrap(

                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text('Apakah Anda ingin Menjualnya?', style:TextStyle(color: Colors.grey)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isForSale = true;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: isForSale ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Ya',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isForSale = false;
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: !isForSale ? Colors.blue : Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Tidak',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],

                            ),
                          );
                        }),
                        // CLEAR
                        if(this.isForSale)TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Harga Buku',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // ... (validator, dsb.)
                        ),
                        SizedBox(height: 8,),
                        TextFormField(
                          controller: pageCountController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Jumlah Halaman Buku',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // ... (validator, dsb.)
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Foto Produk', style:TextStyle(color: Colors.grey)),
                            IconButton(onPressed:  () async {
                              // todo: pakai image picker untuk mendapatkan uin8list
                              final imagePicker = ImagePicker();
                              final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                              if(pickedFile != null){
                                Uint8List imageBytes = await pickedFile.readAsBytes();
                                setState(() {
                                  productsImage.add(imageBytes);
                                });
                              }
                            }, icon: Icon(Icons.add_circle))
                          ],
                        ),
                        productsImage.length != 0?
                        LayoutBuilder(builder: (context, constraints){
                          return Container(
                              width: constraints.maxWidth,
                              height: 200,
                              child:MiniImageContainer(function: (index){
                                setState(() {
                                  productsImage.removeAt(index);
                                });
                              }, imagesData: productsImage)
                          );
                        })
                            :
                        LayoutBuilder(builder: (context, constraints){
                          return Container(

                            height: 200,
                            child: Center(
                              child: Text('Belum ada produk', style: TextStyle(color: Colors.grey),),
                            ),
                          );
                        }),
                        SizedBox(height: 8,), //CLEAR
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kategori', style:TextStyle(color: Colors.grey)),
                          ],

                        ),
                        SizedBox(height: 12,),
                        LayoutBuilder(builder: (context, constraints){
                          return Container(
                            width: constraints.maxWidth,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4,
                              runSpacing: 6,
                              children: [
                                ...productCategories.values.map((categoryData){
                                  String stringValue = categoryData['stringValue'];
                                  return !categoryData['isSelected']?
                                  OutlinedButton(onPressed: (){
                                    setState((){
                                      categoryData['isSelected'] = ! categoryData['isSelected'];
                                    });
                                  }, child:
                                  Text('${stringValue}'
                                  )) :
                                  ElevatedButton(onPressed: (){
                                    setState((){
                                      categoryData['isSelected'] = ! categoryData['isSelected'];
                                    });
                                  }, child:
                                  Text('${stringValue}'
                                  )) ;
                                }).toList()
                              ],
                            ) ,
                          );
                        }),


                      ],
                    ),
                  ),
                )
            )),
            Container(
              width: double.infinity - 40,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ElevatedButton(
                onPressed: (){
                  onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16.0), // Sesuaikan nilai padding sesuai kebutuhan
                ),
                child: isEdit? Text('Edit Buku'):Text('Tambah Buku'),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/api/cloudinary._api.dart';
import 'package:proyek_akhir_semester/Account/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

  class _RegisterPageState extends State<RegisterPage> {
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _fullnameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();
    TextEditingController _ageController = TextEditingController();
    TextEditingController _countryController = TextEditingController();
    TextEditingController _cityController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();
    String _profilePicture = '';

    Future<void> _register() async {
      const String apiUrl = BASE_URL + '/register-flutter/';
      String username = _usernameController.text.trim();
      String fullname = _fullnameController.text.trim();
      String password = _passwordController.text.trim();
      String passwordConfirm = _passwordConfirmController.text.trim();
      String age = _ageController.text.trim();
      String country = _countryController.text.trim();
      String city = _cityController.text.trim();
      String phoneNumber = _phoneNumberController.text.trim();

      if (username.isEmpty ||
          fullname.isEmpty ||
          password.isEmpty ||
          passwordConfirm.isEmpty ||
          age.isEmpty ||
          country.isEmpty ||
          city.isEmpty ||
          phoneNumber.isEmpty){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Terdapat Field Kosong'),
            content:  const Text('Tolong isi semua field. Mungkin Anda lupa scroll ke bawah.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'username': username,
          'fullname': fullname,
          'password': password,
          'password_confirm': passwordConfirm,
          'age': age,
          'country': country,
          'city': city,
          'phone_number': phoneNumber,
          'profile_picture': _profilePicture
        }),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Register Berhasil'),
            content:  const Text('Anda berhasil membuat akun. Anda bisa login sekarang.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Register Gagal'),
            content:  const Text('Terdapat kesalahan internal di server. Register gagal dilakukan.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }


    Future<void> _pickProfilePicture() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      ;
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        String? res =  await uploadImageToCloudinaryPublic(file);

        if (pickedFile != null && res != null) {
          setState(() {
            _profilePicture = res;
          });
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            Expanded(child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Register ke Bookphoria', style: TextStyle(fontWeight:FontWeight.bold, fontSize: 18 , color: Colors.indigoAccent.shade700),),

              ],
            )),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.0),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius:80,
                          backgroundImage: NetworkImage(_profilePicture!.isNotEmpty
                              ? _profilePicture!
                              :'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',),

                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              _pickProfilePicture();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    TextField(
                      controller: _fullnameController,
                      decoration: InputDecoration(
                        labelText: 'Fullname',
                      ),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _passwordConfirmController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                      ),
                    ),
                    TextField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                      ),
                    ),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                      ),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              )),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
                style: ButtonStyle(
                 backgroundColor:  MaterialStateProperty.all<Color>(Colors.indigoAccent.shade700),
                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // Mengatur tinggi tombol dan lebarnya ke maksimum
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ButtonStyle(

                  minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // Mengatur tinggi tombol dan lebarnya ke maksimum
                ),
                child: Text('Login to your account'),
              ),
            ],
          )
        ),
      );
    }
  }
  
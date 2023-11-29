import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/screen/login_page.dart';

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
    File? _profilePicture;

    Future<void> _register() async {
      const String apiUrl = BASE_URL + '/register-flutter/';
      String username = _usernameController.text;
      String fullname = _fullnameController.text;
      String password = _passwordController.text;
      String passwordConfirm = _passwordConfirmController.text;
      String age = _ageController.text;
      String country = _countryController.text;
      String city = _cityController.text;
      String phoneNumber = _phoneNumberController.text;

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'fullname': fullname,
          'password': password,
          'password_confirm': passwordConfirm,
          'age': age,
          'country': country,
          'city': city,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Register Berhasil'),
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

      if (pickedFile != null) {
        setState(() {
          _profilePicture = File(pickedFile.path);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickProfilePicture,
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: _profilePicture != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.file(
                            _profilePicture!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                ),
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
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Login to your account'),
              ),
            ],
          ),
        ),
      );
    }
  }
  
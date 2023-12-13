import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyek_akhir_semester/Account/api/update_profile.dart';
import 'package:proyek_akhir_semester/Account/screens/login_page.dart';
import 'package:proyek_akhir_semester/Account/screens/register_page.dart';
import 'package:proyek_akhir_semester/provider/auth_provider.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';
import 'dart:io';

import '../../api/cloudinary._api.dart';
import '../../models/user.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage();
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> key1 = GlobalKey<ScaffoldState>();
  ResponsiveValue responsiveValue = ResponsiveValue();
  bool _isEditing = false;
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController(); // Add password controller
  String _profilePicture = '';

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
  void initState() {
    super.initState();
    // Check if user is login
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.watch(authProvider);
      setState(() {
        if (user != null){
          _fullnameController.text = user.fullname;
          _countryController.text = user.country;
          _cityController.text = user.city;
          _ageController.text = user.age.toString();
          _phoneNumberController.text = user.phoneNumber;
        }
      });
    });

  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose(); // Dispose password controller
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid
      _formKey.currentState!.save();
      _updateProfile();
    }
  }

  void _updateProfile() async {
    String newFullname = _fullnameController.text;
    String newCountry = _countryController.text;
    String newCity = _cityController.text;
    int newAge = int.parse(_ageController.text);
    String newPhoneNumber = _phoneNumberController.text;
    String password = _passwordController.text; // Get password from controller
    // Access user data from auth provider
    final user = ref.watch(authProvider);
    print(_profilePicture);
    // Create a JSON payload with the updated profile data
    Map<String, dynamic> payload = {
      'id': user!.id,
      'fullname': newFullname,
      'country': newCountry,
      'city': newCity,
      'profilePicture': _profilePicture.isNotEmpty? _profilePicture : user!.profilePicture,
      'age': newAge,
      'phoneNumber': newPhoneNumber,
      'password': password, // Add password to payload
    };

    // Send a POST request to the API endpoint
    final response = await updateProfile(payload);
    print(response);

    if (response == 'SUCCESS') {
      // Profile updated successfully
      User newUser = User(
        id: user!.id,
        username: user!.username,
        fullname: newFullname,
        country: newCountry,
        city: newCity,
        age: newAge,
        phoneNumber: newPhoneNumber,
        profilePicture: user!.profilePicture,
      );
      print(newFullname);
      //update current user data state
      //ref.read(authProvider.notifier).setUserData(newUser);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Updated'),
            content: Text('Your profile has been successfully updated.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Error occurred while updating profile
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed to Update Profile'),
            content: Text('There was an error while updating your profile.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      if(user!= null){
        _fullnameController.text = user.fullname;
        _countryController.text = user.country;
        _cityController.text = user.city;
        _ageController.text = user.age.toString();
        _phoneNumberController.text = user.phoneNumber;
        _passwordController.text = ''; // Clear password field
      }

    }

    // Disable editing mode after saving changes
    _toggleEdit();
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if(user == null){
      return Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, color: Colors.black, size: 3 * responsiveValue.extraTitleFontSize + 24,)
              ],
            ),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('Kamu tidak dapat mengakses halaman ini karena masuk sebagai guest', textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: responsiveValue.subtitleFontSize),))
              ],
            ),
            SizedBox(height: 48,),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the register page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                    padding: EdgeInsets.all(12), // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: responsiveValue.titleFontSize, // Ukuran teks
                      color: Colors.white, // Warna teks
                      fontWeight: FontWeight.bold, // Gaya teks
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to the register page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade500, // Warna latar belakang tombol
                    padding: EdgeInsets.all(12), // Padding tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bentuk tombol dengan sudut melengkung
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: responsiveValue.titleFontSize, // Ukuran teks
                      color: Colors.white, // Warna teks
                      fontWeight: FontWeight.bold, // Gaya teks
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius:80,
                                backgroundImage: NetworkImage(_profilePicture!.isNotEmpty
                                    ? _profilePicture!
                                    : user.profilePicture != null && user.profilePicture!.trim().isNotEmpty? user.profilePicture!:'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',),

                              ),
                              if(_isEditing)Positioned(
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
                        ],
                      ),
                      SizedBox(height:8),
                      Text(
                        "Full Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _fullnameController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Country",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _countryController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          hintText: "Enter your country",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "City",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _cityController,
                        enabled: _isEditing,
                        decoration: InputDecoration(
                          hintText: "Enter your city",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Age",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _ageController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter your age",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _phoneNumberController,
                        enabled: _isEditing,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field must not be empty";
                          }
                          return null;
                        },
                      ),
                      if (_isEditing) ...[
                        SizedBox(height: 16.0),
                        Text(
                          "Password", // Add password field
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordController,
                          enabled: _isEditing,
                          obscureText: true, // Hide password text
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "This field must not be empty";
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
            child: Icon(_isEditing ? Icons.save : Icons.edit),
          ),
        ),
      ],
    );
  }
}
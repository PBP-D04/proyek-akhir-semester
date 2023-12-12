import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyek_akhir_semester/Account/api/update_profile.dart';
import 'package:proyek_akhir_semester/util/responsive_config.dart';
import 'package:proyek_akhir_semester/widgets/appbar.dart';
import 'package:proyek_akhir_semester/widgets/drawer.dart';

import '../../models/user.dart';

class ProfilePage extends ConsumerStatefulWidget {
  User user;
  ProfilePage({required this.user});
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

  @override
  void initState() {
    super.initState();
    _fullnameController.text = widget.user.fullname;
    _countryController.text = widget.user.country;
    _cityController.text = widget.user.city;
    _ageController.text = widget.user.age.toString();
    _phoneNumberController.text = widget.user.phoneNumber;
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

    // Create a JSON payload with the updated profile data
    Map<String, dynamic> payload = {
      'id': widget.user.id,
      'fullname': newFullname,
      'country': newCountry,
      'city': newCity,
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
        id: widget.user.id,
        username: widget.user.username,
        fullname: newFullname,
        country: newCountry,
        city: newCity,
        age: newAge,
        phoneNumber: newPhoneNumber,
        profilePicture: widget.user.profilePicture,
      );
      widget.user = newUser;
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
      _fullnameController.text = widget.user.fullname;
      _countryController.text = widget.user.country;
      _cityController.text = widget.user.city;
      _ageController.text = widget.user.age.toString();
      _phoneNumberController.text = widget.user.phoneNumber;
      _passwordController.text = ''; // Clear password field
    }

    // Disable editing mode after saving changes
    _toggleEdit();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key1,
      drawer: MyDrawer(
          callBack: (identifier){},
      ),
      appBar: MyAppBar(scaffoldKey: key1, title: 'Profile',),
      body: Stack(
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
      ),
    );
  }
}
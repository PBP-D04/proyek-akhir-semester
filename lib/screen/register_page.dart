import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyek_akhir_semester/api/api_config.dart';
import 'package:proyek_akhir_semester/screen/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    const String apiUrl = BASE_URL+'/register-flutter/'; // Ganti dengan URL endpoint login Anda
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': username,
        'password': password,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
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

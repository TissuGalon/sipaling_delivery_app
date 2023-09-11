import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/main.dart';
import 'package:mydelivery/proses/register_page.dart';
import 'package:mydelivery/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Simpan data sesi pengguna setelah login
  void saveUserSession(
      String authToken, String uid, Map<String, dynamic> all) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', authToken);
    prefs.setString('uid', uid);

    final jsonData = jsonEncode(all);
    prefs.setString('allUserData', jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/login_illustration.png'),
                  Text(
                    'LOGIN NOW',
                    style: TextStyle(
                        fontFamily: 'URW',
                        fontSize: 35,
                        color: Warna.TextBold,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Mohon login untuk melanjutkan',
                    style: TextStyle(
                      fontFamily: 'URW',
                      fontSize: 16,
                      color: Warna.TextBold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              /* LOGIN TEXTFIELD */
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color:
                            Colors.grey[200]!), // Warna border saat tidak aktif
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.pink), // Warna border saat aktif (focus)
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  hintText: 'Enter your username',
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Warna.Primary, // Warna ikon saat tidak aktif
                  ),
                  labelStyle: TextStyle(
                    color: Warna.Primary, // Warna label saat aktif (focus)
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color:
                            Colors.grey[200]!), // Warna border saat tidak aktif
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color: Colors.pink), // Warna border saat aktif (focus)
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  hintText: 'Enter your password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Warna.Primary, // Warna ikon saat tidak aktif
                  ),
                  labelStyle: TextStyle(
                    color: Colors.pink, // Warna label saat aktif (focus)
                  ),
                ),
              ),

              /* LOGIN TEXTFIELD */

              /* LOGIN BUTTON */
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () async {
                  final id = _phoneController.text;
                  final password = _passwordController.text;

                  final domain = alamatAPI();

                  final apiUrl =
                      '$domain/user/user_login.php?id=$id&password=$password'; // Replace with your API endpoint URL

                  try {
                    final response = await http.post(Uri.parse(apiUrl));

                    if (response.statusCode == 200) {
                      // The API returned a successful response, indicating a valid login
                      // Store the user's login status in shared preferences
                      if (response.body.toString() == "failed") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                              'Login Gagal, Nomor HP atau Password tidak valid !'),
                        ));
                      } else {
                        Map<String, dynamic> data = jsonDecode(response.body);
                        print(data['Account_ID']);

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', true);

                        Map<String, dynamic> allUserData = data;

                        saveUserSession(data['Account_ID'], data['Account_ID'],
                            allUserData);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              'Login Berhasil ! Selamat datang ${data['Username']}'),
                        ));

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      }
                    } else {
                      // The API returned an error response, indicating invalid credentials
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Terjadi Kesalahan Server'),
                      ));
                    }
                  } catch (e) {
                    // An error occurred while making the API request
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content:
                          Text('An error occurred. Please try again later.'),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Warna
                      .Primary, // Set the button's background color to pink
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30.0), // Set the border radius to make it rounded
                  ),
                  minimumSize: Size(double.infinity, 48.0), // Set full width
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 24.0, // Set the font size of the button text
                      fontWeight: FontWeight.bold,
                      fontFamily: 'URW'),
                ),
              ),
              /* LOGIN BUTTON */

              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun ?',
                    style: TextStyle(fontSize: 17, fontFamily: 'URW'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RegisterPage())),
                    child: Text(
                      'DAFTAR SEKARANG',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'URW',
                          color: Warna.Primary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

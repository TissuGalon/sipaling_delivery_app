import 'package:flutter/material.dart';
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/warna.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

void main() => runApp(RegisterApp());

class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool _isButtonEnabled = false;

  bool isRegisterLoading = false;
  /* STEP1 */
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pass1Controller = TextEditingController();
  TextEditingController _pass2Controller = TextEditingController();
  /* Check Textfield Step1 isFilled */
  bool _validateFields() {
    return _usernameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _pass1Controller.text.isNotEmpty &&
        _pass2Controller.text.isNotEmpty;
  }
  /* Check Textfield Step1 isFilled */

  /* CHECK PASSWORD SAMA */
  bool _validatePasswordMatch() {
    return _pass1Controller.text == _pass2Controller.text;
    /* CHECK PASSWORD SAMA */
  }

  /* CHECK FORMAT EMAIL */
  bool _isValidEmail(String email) {
    // Regular expression to match a valid email address pattern
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  /* CHECK FORMAT EMAIL */

  /* STEP1 */

  /* STEP2 */
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _genderpass1Controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime
          .now(), // You can adjust this to limit the latest allowed date
    );

    if (picked != null) {
      print('Selected date: ${picked.toLocal()}');
      setState(() {
        _birthdateController.text = picked
            .toString()
            .split(' ')[0]; // Extract the date part without the time
      });
    }
  }

  String selectedgender = ''; // Store the selected option here

  List<String> opsiGender = ['Laki-Laki', 'Perempuan', 'Lainnya'];

  /* STEP2 */

  // Tambahkan variabel pengunci
  bool _isLocked = true;

  void _nextPage() {
    if (_isLocked) return; // Jika halaman terkunci, jangan izinkan berpindah
    if (_currentPage < 2) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage++;
        _isLocked = true;
      });
    }
  }

  void _previousPage() {
    if (_isLocked) return; // Jika halaman terkunci, jangan izinkan berpindah
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage--;
      });
    }
  }

  void _updateButtonState() {
    if (_currentPage == 0) {
      _isButtonEnabled = _emailController.text.isNotEmpty;
    } else if (_currentPage == 1) {
      /* _isButtonEnabled = _nameController.text.isNotEmpty; */
    } else if (_currentPage == 2) {
      _isButtonEnabled = _phoneController.text.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF222222),
          ),
        ),
        title: Text(
          'DAFTAR AKUN',
          style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: _isLocked
                    ? NeverScrollableScrollPhysics()
                    : null, // Terapkan penguncian
                children: <Widget>[
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: Text('Kembali'),
                  ),
                _isLocked
                    ? Container() //Kosong
                    : ElevatedButton(
                        onPressed: _nextPage,
                        child:
                            Text(_currentPage == 2 ? 'Selesai' : 'Selanjutnya'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Warna.Primary)),
                      )
              ],
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return ListView(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18.0), // Adjust the radius as needed
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text('Daftar Akun'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'URW')),
                ),
                SizedBox(
                  height: 15,
                ),
                /* USERNAME */
                TextField(
                  controller: _usernameController,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Buat username Anda',
                    suffixIcon: Icon(
                      Icons.alternate_email,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* USERNAME */
                SizedBox(
                  height: 10,
                ),
                /* EMAIL */
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* EMAIL */
                SizedBox(
                  height: 10,
                ),
                /* NOHP */
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'No Whatsapp / HP',
                    hintText: '*Contoh: 0812 3456 789',
                    suffixIcon: Icon(
                      Icons.phone,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* NOHP */
                SizedBox(
                  height: 15,
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                /* PASSWORD 1 */
                TextField(
                  controller: _pass1Controller,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan Password',
                    suffixIcon: Icon(
                      Icons.key,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* PASSWORD 1 */
                SizedBox(
                  height: 15,
                ),
                /* PASSWORD 2 */
                TextField(
                  controller: _pass2Controller,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Masukkan Password',
                    suffixIcon: Icon(
                      Icons.key,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* PASSWORD 2 */
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: isRegisterLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Warna.Primary,
                            backgroundColor: Warna.BG,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isRegisterLoading = true;
                            });
                            if (_validateFields() &&
                                _validatePasswordMatch() &&
                                _isValidEmail(_emailController.text)) {
                              final alamat =
                                  '${alamatAPI()}/user/user_register.php';

                              Uri registrationUrl = Uri.parse(alamat);
                              registrationUrl =
                                  registrationUrl.replace(queryParameters: {
                                "username": _usernameController.text,
                                "password": _pass1Controller.text,
                                "phone": _phoneController.text,
                                "email": _emailController.text,
                                "type": "User",
                              });

                              final response = await http.get(registrationUrl);

                              if (response.statusCode == 200) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Pemberitahuan'.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'URW',
                                              fontWeight: FontWeight.bold)),
                                      content: Text(
                                        json.decode(response.body)['message'],
                                        style: const TextStyle(
                                            fontFamily: 'URW', fontSize: 16),
                                      ), // Assuming your API returns a message in the response
                                      actions: [
                                        TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Warna.Primary)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'URW',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                setState(() {
                                  if (json.decode(response.body)['success']) {
                                    _isLocked = false;
                                    _nextPage();
                                  }
                                  isRegisterLoading = false;
                                });
                              } else {
                                // Registration failed, show an error message in an alert dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text(
                                          'Terjadi kesalahan pada Server.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'URW'),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else if (!_validatePasswordMatch()) {
                              // Passwords don't match, show an error
                              isRegisterLoading = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Password tidak sama.'),
                                ),
                              );
                            } else {
                              // Some fields are empty or email is invalid, show an error
                              isRegisterLoading = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Mohon Lengkapi seluruh kolom pada form.'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Warna
                                .Primary, // Set the button's background color to pink
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Set the border radius to make it rounded
                            ),
                            minimumSize:
                                Size(double.infinity, 48.0), // Set full width
                          ),
                          child: Text(
                            'DAFTAR',
                            style: TextStyle(
                                fontSize:
                                    24.0, // Set the font size of the button text
                                fontWeight: FontWeight.bold,
                                fontFamily: 'URW'),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return ListView(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18.0), // Adjust the radius as needed
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text('BIODATA'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'URW')),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                /* FULL NAME */
                TextField(
                  controller: _fullnameController,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan Nama Lengkap Anda',
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* FULL NAME */
                SizedBox(
                  height: 10,
                ),
                /* ALAMAT */
                TextField(
                  controller: _addressController,
                  onChanged: (value) {
                    setState(() {
                      _updateButtonState();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    hintText: 'Masukkan Alamat anda',
                    suffixIcon: Icon(
                      Icons.home,
                      color: Colors.pink, // Ubah warna ikon menjadi pink
                    ),
                    contentPadding:
                        EdgeInsets.all(16.0), // Padding sekitar teks
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          12.0), // Sesuaikan radius agar terlihat bulat
                    ),
                  ),
                ),
                /* ALAMAT */
                SizedBox(
                  height: 10,
                ),
                /* TGL LAHIR */
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _birthdateController,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          hintText: 'Input Tanggal Lahir anda',
                          suffixIcon: Icon(
                            Icons.cake_outlined,
                            color: Colors.pink, // Ubah warna ikon menjadi pink
                          ),
                          contentPadding:
                              EdgeInsets.all(16.0), // Padding sekitar teks
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                12.0), // Sesuaikan radius agar terlihat bulat
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Warna.Primary)),
                          child: Icon(Icons.date_range_outlined)),
                    )
                  ],
                ),
                /* TGL LAHIR */
                SizedBox(
                  height: 10,
                ),
                /* GENDER */

                /* GENDER */
                SizedBox(
                  height: 15,
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLocked = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Warna
                          .Primary, // Set the button's background color to pink
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Set the border radius to make it rounded
                      ),
                      minimumSize:
                          Size(double.infinity, 48.0), // Set full width
                    ),
                    child: Text(
                      'SIMPAN',
                      style: TextStyle(
                          fontSize:
                              24.0, // Set the font size of the button text
                          fontWeight: FontWeight.bold,
                          fontFamily: 'URW'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Verifikasi No. HP',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        TextField(
          controller: _phoneController,
          onChanged: (value) {
            setState(() {
              _updateButtonState();
            });
          },
          decoration: InputDecoration(labelText: 'No. HP'),
        ),
      ],
    );
  }
}

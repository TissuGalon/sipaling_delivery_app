import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydelivery/warna.dart';

void main() => runApp(RegisterApp());

class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Tambahkan variabel untuk menyimpan path gambar yang diunggah
  String imagePath = '';

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      } else {
        imagePath = '';
      }
    });
  }

  int currentStep = 0;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController =
      TextEditingController(); // Tambahkan phone
  TextEditingController addressController =
      TextEditingController(); // Tambahkan alamat
  TextEditingController dateOfBirthController =
      TextEditingController(); // Tambahkan tanggal lahir
  TextEditingController genderController =
      TextEditingController(); // Tambahkan jenis kelamin
  TextEditingController imageUploadController =
      TextEditingController(); // Tambahkan upload gambar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* APPBAR */
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
      /* APPBAR */
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepContinue: () {
          if (currentStep < 3) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Akun'),
            isActive: currentStep == 0,
            content: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: phoneController, // Tambahkan Phone
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Biodata'),
            isActive: currentStep == 1,
            content: Column(
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Nama Lengkap'),
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                ),
                TextFormField(
                  controller: dateOfBirthController,
                  decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                ),
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _pickImageFromGallery(), // Tombol untuk memilih gambar dari galeri
                  child: Text('Unggah Gambar'),
                ),
                if (imagePath != null)
                  Image.file(
                    File(imagePath), // Menampilkan gambar yang sudah diunggah
                    width: 100,
                    height: 100,
                  ),
              ],
            ),
          ),
          Step(
            title: Text('Verifikasi'),
            isActive: currentStep == 2,
            content: Column(
              children: [
                Text(
                    'Silakan masukkan kode verifikasi yang telah Anda terima.'),
                TextFormField(
                  controller: imageUploadController, // Tambahkan Upload Gambar
                  decoration: InputDecoration(labelText: 'Upload Gambar'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle form submission here
          String username = usernameController.text;
          String password = passwordController.text;
          String fullName = fullNameController.text;
          String email = emailController.text;
          String phone = phoneController.text;
          String address = addressController.text;
          String dateOfBirth = dateOfBirthController.text;
          String gender = genderController.text;
          String imageUpload = imageUploadController.text;

          // Lakukan logika verifikasi dan penanganan sesuai kebutuhan

          // Reset the form after submission
          usernameController.clear();
          passwordController.clear();
          fullNameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController.clear();
          dateOfBirthController.clear();
          genderController.clear();
          imageUploadController.clear();

          // Move to the next step or navigate to another page as needed
          setState(() {
            currentStep = 0; // Reset to the first step
          });
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

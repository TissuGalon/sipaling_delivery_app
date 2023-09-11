import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydelivery/main.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:mydelivery/warna.dart';

void main() {
  runApp(MaterialApp(home: ProfilDetail()));
}

class ProfilDetail extends StatefulWidget {
  @override
  _ProfilDetailScreenState createState() => _ProfilDetailScreenState();
}

class _ProfilDetailScreenState extends State<ProfilDetail> {
  bool isLoading = true; // Initially set to true when the screen loads
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    getDataProfilUser();
  }

  /* GET DATA PROFIL USER*/
  void getDataProfilUser() async {
    Map<String, dynamic> data = await getAllUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }
  /* GET DATA PROFIL USER*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.Primary,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF27FAC7),
          ),
        ),
        title: Text(
          'PROFIL',
          style: TextStyle(
              color: Color(0xFF27FAC7),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        actions: [],
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 55,
                    backgroundColor: Warna.Primary,
                    backgroundImage: NetworkImage(
                      'https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',
                    ),
                  ),
            SizedBox(height: 10),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ) // Show shimmer skeleton while loading
                : Text(
                    userData['User_Data']['Fullname'] ?? 'Username',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'URW'),
                  ),
            SizedBox(height: 5),
            _levelakun('Bronze', Colors.brown, Icons.assistant_outlined),
            SizedBox(height: 20),

            /* PROFIL */

            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.email_outlined,
                    'Username',
                    userData['User_Data']['Username'] ?? 'Null',
                  ),
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.person_outline,
                    'Nama Lengkap',
                    userData['User_Data']['Fullname'] ?? 'Null',
                  ),
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.location_on_outlined,
                    'Alamat',
                    userData['User_Data']['Address'] ?? 'Null',
                  ),
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.date_range_outlined,
                    'Tanggal Lahir',
                    userData['User_Data']['DateofBirth'] ?? 'Null',
                  ),
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.people_alt_outlined,
                    'Jenis Kelamin',
                    userData['User_Data']['Gender'] ?? 'Null',
                  ),
            /* PROFIL */
            Divider(),
            /* AKUN */
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.email_outlined,
                    'Email',
                    userData['Email'] ?? 'Null',
                  ),
            isLoading
                ? _shimmerInfoItem() // Show shimmer skeleton while loading
                : _buildInfoItem(
                    Icons.phone_outlined,
                    'No HP',
                    userData['Phone'] ?? 'Null',
                  ),
            /* AKUN */

            //EDIT PROFIL BUTTON
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  /*   Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage())); */
                },
                style: ElevatedButton.styleFrom(
                  primary: Warna.Primary,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
                label: Text(
                  'Edit Profile',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'URW'),
                ),
              ),
            )
            //EDIT PROFIL BUTTON
          ],
        ),
      ),
    );
  }

  /* LEVEL */
  Widget _levelakun(String text, Color color, IconData iconData) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: color,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  /* LEVEL */

  /* INFO */
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'URW'),
              ),
              Text(value, style: TextStyle(fontSize: 16, fontFamily: 'URW')),
            ],
          ),
        ],
      ),
    );
  }
  /* INFO */

  /* HEADER */
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
  /* HEADER */

  /* SHIMMER SKELETON */
  Widget _shimmerInfoItem() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* SHIMMER SKELETON */
}

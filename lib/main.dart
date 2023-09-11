import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mydelivery/2riwayat_transaksi.dart';
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/chat_room.dart';
import 'package:mydelivery/keranjang.dart';
import 'package:mydelivery/membership_page.dart';
import 'package:mydelivery/notifikasi.dart';
import 'package:mydelivery/page_food.dart';
import 'package:mydelivery/profil_detail.dart';
import 'package:mydelivery/proses/login_page.dart';
import 'package:mydelivery/proses/test_tampill.dart';
import 'package:mydelivery/refferral_page.dart';
import 'package:mydelivery/rekomendasi_makanan.dart';
import 'package:mydelivery/rupiah_format.dart';
import 'package:mydelivery/warna.dart';
import 'package:mydelivery/pencarian.dart';
import 'package:mydelivery/riwayat_transaksi.dart';
import 'package:mydelivery/detail_menu.dart';
import 'package:mydelivery/proses/test_tampill.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/* PROSES API  */
import 'package:mydelivery/proses/get data.dart';

/* API */
import 'package:mydelivery/api/api_call.dart';
/* API */

/* DAPATKAN SELURUH DATA LLOGIN USER */
Future<Map<String, dynamic>> getAllUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonDataString = prefs.getString('allUserData');

  if (jsonDataString != null) {
    final jsonData = jsonDecode(jsonDataString);
    return jsonData;
  } else {
    return {}; // Mengembalikan objek kosong jika tidak ada data 'allUserData'
  }
}
/* DAPATKAN SELURUH DATA LLOGIN USER */

void main() {
  runApp(MyApp());
  //STATUSBAR WARNA
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Replace this with your desired color
    statusBarBrightness:
        Brightness.light, // Change this to change text color of status bar
  ));
  //STATUSBAR WARNA
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor:
            Warna.Primary, // Mengubah warna utama aplikasi menjadi pink
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        // RUTE DI page_food.dart
        '/terdekat': (context) => ProfilDetail(),
        '/diskon': (context) => ProfilDetail(),
        '/terbaru': (context) => ProfilDetail(),
        '/terbaik': (context) => ProfilDetail(),
        '/history': (context) => ProfilDetail(),
        // RUTE DI page_food.dart
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  /* CHECK LOGIN */
  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await isUserLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if the 'isLoggedIn' key exists and its value is true.
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
  /* CHECK LOGIN */

  final List<Widget> _pages = [
    HalamanUtama(),
    ChatPage(),
    PesananPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      // If the user is not logged in, navigate to the login page
      return LoginPage(); // Replace with the actual login page widget
    }

    return Scaffold(
      backgroundColor: Warna.BG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'SIPALING APP',
          style: TextStyle(
              color: Warna.Primary,
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => notifikasi())),
            icon: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 250, 187, 39),
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),

      //SIDEBAR
      drawer: SideBar(),
      //SIDEBAR
      body: _pages[_currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          backgroundColor: Warna.BG,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(Icons.home_outlined),
            Icon(Icons.question_answer_outlined),
            Icon(Icons.receipt_long_outlined),
            Icon(Icons.person_outline),
          ]),

      /* ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          unselectedItemColor: Warna.TextBold,
          selectedItemColor: Warna.Primary,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer_outlined),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ), */
    );
  }
}

class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

//HALAMAN PERTAMA
class _HalamanUtamaState extends State<HalamanUtama> {
  bool isLoadingProfil = true;
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
      isLoadingProfil = false;
    });
  }
  /* GET DATA PROFIL USER*/

  /* SHIMMER SKELETON */
  Shimmer buildShimmerAvatar() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
      ),
    );
  }

  Shimmer buildShimmerText(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }
  /* SHIMMER SKELETON */

  //IMAGE URL
  final List<String> imageUrls = [
    'https://lelogama.go-jek.com/post_featured_image/Super-App-Gojek-Banner.jpg',
    'https://lelogama.go-jek.com/cms_editor/2021/04/14/top-banner-1-ID.jpg',
    'https://gobiz.co.id/pusat-pengetahuan/wp-content/uploads/2022/03/Jangkau-Lebih-Banyak-Pelanggan-dengan-Buat-Iklan-GoFood-Top-Banner.jpg',
    // Add more image URLs here
  ];
  //IMAGE URL

  final productService =
      ProductService('https://maxappid.com/api_sipaling/all/all_product.php');

  @override
  Widget build(BuildContext context) {
    return Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.

      child: ListView(children: <Widget>[
        Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => pencarian())),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      backgroundColor: MaterialStateProperty.all(
                          Colors.grey.shade50), // Background color
                    ),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    label: Text('Cari layanan, makanan, & tujuan',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 1.0, left: 5, right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 175, // Set the height of the carousel
                    aspectRatio: 16 / 9, // Set the aspect ratio of the carousel
                    autoPlay:
                        true, // Set auto-play to true for automatic sliding
                    enlargeCenterPage:
                        true, // Set to true for the center item to be larger
                  ),
                  items: imageUrls.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            //WALLET BAR
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on_outlined,
                          size: 20,
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '2000',
                            style: TextStyle(
                                color: Warna.Primary,
                                fontFamily: 'URW',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'Coin',
                          style: TextStyle(
                              color: Warna.TextBold,
                              fontFamily: 'URW',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp. ',
                          style: TextStyle(
                              color: Warna.TextBold,
                              fontFamily: 'URW',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            '150.000',
                            style: TextStyle(
                                fontFamily: 'URW',
                                color: Warna.Primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 20,
                          color: Warna.TextNormal,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //WALLET BAR

            //LEVEL BAR
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => membership_page()));
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  backgroundColor: Colors.white,
                  primary: Colors.white, // Set the text color to orange
                ),
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: isLoadingProfil
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                buildShimmerAvatar(),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildShimmerText(150, 18),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          buildShimmerText(60, 16),
                                          SizedBox(width: 5),
                                          buildShimmerText(40, 16),
                                          SizedBox(width: 5),
                                          buildShimmerText(30, 16),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Warna.Primary,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/me.jpeg'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userData['User_Data']['Fullname'],
                                        style: TextStyle(
                                            fontFamily: 'URW',
                                            fontSize: 18,
                                            color: Warna.TextBold,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Bronze',
                                            style: TextStyle(
                                                fontFamily: 'URW',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown),
                                          ),
                                          Text(
                                            '•',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              '1000',
                                              style: TextStyle(
                                                  color: Warna.Primary),
                                            ),
                                          ),
                                          Text(
                                            'Poin',
                                            style: TextStyle(
                                                color: Warna.TextNormal),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Warna.Primary,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            //LEVEL BAR

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //DELIVERY
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 172,
                        height: 65,
                        child: TextButton(
                          onPressed: () {
                            // Add your button press logic here
                            print('Button pressed!');
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                            backgroundColor: Warna.Primary,
                            primary:
                                Colors.white, // Set the text color to orange
                          ),
                          child: Text(
                            'DELIVERY',
                            style: TextStyle(
                                fontFamily: 'URW',
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ),

                    //LAUNDRY
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 172,
                        height: 65,
                        child: TextButton(
                          onPressed: () {
                            // Add your button press logic here
                            print('Button pressed!');
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                            backgroundColor: Warna.Primary,
                            primary:
                                Colors.white, // Set the text color to orange
                          ),
                          child: Text(
                            'LAUNDRY',
                            style: TextStyle(
                                fontFamily: 'URW',
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //DISINI
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CellWidget(
                          firstLineGambar: 'assets/icon/food.png',
                          secondLineText: 'FOOD',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PageFood()));
                          },
                        ),
                      ),
                      Expanded(
                        child: CellWidget(
                          firstLineGambar: 'assets/icon/grocery.png',
                          secondLineText: 'GROSIR',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detail_menu()));
                          },
                        ),
                      ),
                      Expanded(
                        child: CellWidget(
                          firstLineGambar: 'assets/icon/shampoo.png',
                          secondLineText: 'BEAUTY',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detail_menu()));
                          },
                        ),
                      ),
                      Expanded(
                        child: CellWidget(
                          firstLineGambar: 'assets/icon/2medicine.png',
                          secondLineText: 'APOTEK',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => detail_menu()));
                          },
                        ),
                      ),
                    ],
                  ),
                  /* Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CellWidget(
                        firstLineGambar: 'assets/images/me.jpeg',
                        secondLineText: 'Line 2 Text',
                      ),
                    ),
                    Expanded(
                      child: CellWidget(
                        firstLineGambar: 'assets/images/me.jpeg',
                        secondLineText: 'Line 2 Text',
                      ),
                    ),
                    Expanded(
                      child: CellWidget(
                        firstLineGambar: 'assets/images/me.jpeg',
                        secondLineText: 'Line 2 Text',
                      ),
                    ),
                    Expanded(
                      child: CellWidget(
                        firstLineGambar: 'assets/images/me.jpeg',
                        secondLineText: 'Line 2 Text',
                      ),
                    ),
                  ],
                ), */
                ],
              ),
            ),

            /* PROGRAM REFERRAL */
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 246, 246, 246))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => referral_page()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Text(
                        'PROGRAM REFERRAL',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'URW',
                          fontWeight: FontWeight.w800,
                          color: Warna.TextBold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/referral_illustration.gif',
                              height: ScreenUtil().setSp(80),
                              width: ScreenUtil().setSp(80),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Expanded(
                          // Wrap the red Container with Expanded to make it follow the parent's maximum width
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Undang Temanmu',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  fontFamily: 'URW',
                                  fontWeight: FontWeight.bold,
                                  color: Warna.TextBold,
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Ajak temanmu untuk download aplikasi Sipaling Delivery',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(13),
                                  fontFamily: 'URW',
                                  color: Warna.TextNormal,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                'Pelajari Lebih Lanjut',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  fontFamily: 'URW',
                                  fontWeight: FontWeight.bold,
                                  color: Warna.Primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            /* PROGRAM REFERRAL */

            //RIWAYAT TRANSAKSI

            //RIWAYAT TRANSAKSI
          ],
        ),
      ]),
    );
  }
}

class CellWidget extends StatelessWidget {
  final String firstLineGambar;
  final String secondLineText;
  final VoidCallback? onPressed;

  CellWidget({
    required this.firstLineGambar,
    required this.secondLineText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  firstLineGambar, // Replace with your image path
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(height: 8),
              Text(
                secondLineText,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: Warna.TextBold,
                    fontFamily: 'URW',
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//HALAMAN PERTAMA

//HALAMAN KEDUA
class MenuItem {
  final String title;
  final String description;
  final String price;
  final String image;

  MenuItem({
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });
}

class ChatPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(
      title: "Muhammad Kholis",
      description: "Message here...",
      price: "\$12.99",
      image: "assets/images/me.jpeg",
    ),
    MenuItem(
      title: "Parzival",
      description: "Message Here.",
      price: "\$8.99",
      image: "assets/images/me.jpeg",
    ),
    // Add more menu items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.BG,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "CHAT",
          style: TextStyle(
              color: Warna.TextBold,
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return MenuItemCard(menuItem: menuItems[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
          print('Floating Action Button pressed!');
        },
        child: Icon(Icons.chat),
        backgroundColor: Warna.Primary, // Set the button's background color
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  MenuItemCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => chat_room())),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Added this line
            children: [
              /* ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://img.freepik.com/free-psd/3d-rendering-delicious-cheese-burger_23-2149108546.jpg?w=2000',
                  width: 80,
                  height: 80,
                  fit: BoxFit
                      .cover, // Added this line to fit the image inside the container
                ),
              ), */
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CircleAvatar(
                  child: Image.network(
                    'https://i.pinimg.com/564x/21/70/27/21702798735c9fcecfac0d9c3b3b0ad5.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit
                        .cover, // Added this line to fit the image inside the container
                  ),
                  backgroundColor: Warna.TextNormal,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Muhammad Khois',
                      style: TextStyle(
                        fontFamily: 'URW',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Warna.TextBold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Pesan',
                        style: TextStyle(color: Warna.TextNormal),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//HALAMAN KEDUA

//HALAMAN PESANAN
class PesananPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Warna.BG,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 10,
          backgroundColor: Colors.white,
          bottom: TabBar(
            labelColor: Warna.TextBold,
            tabs: [
              Tab(
                child: Text(
                  'DALAM PROSES',
                  style: TextStyle(
                      fontFamily: 'URW',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                child: Text(
                  'RIWAYAT',
                  style: TextStyle(
                      fontFamily: 'URW',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /* DALAM PROSES */
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Added this line
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://img.freepik.com/free-psd/3d-rendering-delicious-cheese-burger_23-2149108546.jpg?w=2000',
                              width: 80,
                              height: 80,
                              fit: BoxFit
                                  .cover, // Added this line to fit the image inside the container
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Orderan #9w8eufsdfkjmskljndfkld',
                                  style: TextStyle(
                                    fontFamily: 'URW',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Warna.TextBold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Item1, Item2, Item3',
                                    style: TextStyle(color: Warna.TextNormal),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Text(
                                  'Rp. 24.000',
                                  style: TextStyle(
                                    fontFamily: 'URW',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Warna.Primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end, // Added this line
                            children: [
                              Text(
                                '2 Agustus 2023',
                                style: TextStyle(
                                  fontFamily: 'URW',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Warna.Primary),
                                ),
                                child: Text(
                                  'Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'URW',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            //DALAM PROSES
            //RIWAYAT
            ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Added this line
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://img.freepik.com/free-psd/3d-rendering-delicious-cheese-burger_23-2149108546.jpg?w=2000',
                              width: 80,
                              height: 80,
                              fit: BoxFit
                                  .cover, // Added this line to fit the image inside the container
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Orderan #9w8eufsdfkjmskljndfkld',
                                  style: TextStyle(
                                    fontFamily: 'URW',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Warna.TextBold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Item1, Item2, Item3',
                                    style: TextStyle(color: Warna.TextNormal),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Text(
                                  'Rp. 24.000',
                                  style: TextStyle(
                                    fontFamily: 'URW',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Warna.Primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end, // Added this line
                            children: [
                              Text(
                                '2 Agustus 2023',
                                style: TextStyle(
                                  fontFamily: 'URW',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Warna.Primary),
                                ),
                                child: Text(
                                  'Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'URW',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            //RIWAYAT
          ],
        ),
      ),
    );
  }
}
//HALAMAN PESANAN

//HALAMAN PROFIL
class ProfilePage extends StatelessWidget {
  void _showLogoutDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LogoutConfirmationDialog(
          onLogout: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('authToken');
            prefs.remove('uid');
            prefs.setBool('isLoggedIn', false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Warna.BG,
      body: ListView(
        children: [
          Column(
            children: [
              Card(
                color: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2),
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilDetail())),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/images/me.jpeg'),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MUHAMMAD KHOLIS',
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.023,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'URW',
                                      color: Warna.TextBold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Tampilkan Profil',
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.018,
                                      fontWeight: FontWeight.normal,
                                      color: Warna.TextNormal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Warna.Primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    //ITEM 1
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.person_outline,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Pengaturan Akun',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                    //ITEM 2
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.favorite_outline,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Favorit Saya',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                    //ITEM 3
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.assistant_outlined,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Level Anda',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                    //ITEM 4
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.payment_outlined,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Metode Pembayaran',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                    //ITEM 5
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.settings_outlined,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    //ITEM 6 (Logout)
                    TextButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                10), // Sesuaikan padding sesuai kebutuhan
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Warna.Primary,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16.sp, // Sesuaikan ukuran font sesuai kebutuhan
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//HALAMAN PROFIL

/* SIDEBAR */
class SideBar extends StatelessWidget {
  void _showLogoutDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LogoutConfirmationDialog(
          onLogout: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('authToken');
            prefs.remove('uid');
            prefs.setBool('isLoggedIn', false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        );
      },
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Warna.Primary),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Warna.PrimaryDark,
              ),
              child: Container(
                margin: EdgeInsets.all(5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              'assets/images/me.jpeg'), // Replace with your image asset path
                        ),
                      ),
                      Text(
                        'MUHAMMAD KHOLIS'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.03,
                            fontFamily: 'URW',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'BRONZE, 0 Poin',
                        style: TextStyle(
                            color: Warna.Secondary,
                            fontSize: screenHeight * 0.02,
                            fontWeight: FontWeight.w400),
                      ),
                    ]),
              ),
            ),

            Container(
              width: double.infinity,
              height: 500,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      /* HOME */
                      ListTile(
                        selectedColor: Warna.Secondary,
                        leading: Icon(
                          Icons.home_outlined,
                          color: Warna.Secondary,
                          size: 28,
                        ),
                        title: Text(
                          'Home'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'URW',
                              fontSize: screenHeight * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Handle navigation to the home screen
                        },
                      ),
                      /* HOME */
                      /* PESANAN */
                      ListTile(
                        leading: Icon(
                          Icons.receipt_long_outlined,
                          color: Warna.Secondary,
                          size: 28,
                        ),
                        title: Text(
                          'PESANAN'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'URW',
                              fontSize: screenHeight * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // Handle navigation to the home screen
                        },
                      ),
                      /* PESANAN */
                      /* PROFIL */
                      ExpansionTile(
                        leading: Icon(
                          Icons.person_outline,
                          color: Warna.Secondary,
                          size: 28,
                        ),
                        title: Text(
                          'PROFIL'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'URW',
                              fontSize: screenHeight * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              color: Warna.Secondary,
                              size: 20,
                            ),
                            title: Text(
                              'Profil Saya',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'URW',
                                fontSize: screenHeight * 0.019,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.favorite_outlined,
                              color: Warna.Secondary,
                              size: 20,
                            ),
                            title: Text(
                              'Favorite Saya',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'URW',
                                fontSize: screenHeight * 0.019,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.assistant_outlined,
                              color: Warna.Secondary,
                              size: 20,
                            ),
                            title: Text(
                              'Level Saya',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'URW',
                                fontSize: screenHeight * 0.019,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.credit_card_outlined,
                              color: Warna.Secondary,
                              size: 20,
                            ),
                            title: Text(
                              'Metode Pembayaran',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'URW',
                                fontSize: screenHeight * 0.019,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      /* PROFIL */
                      /* PENGATURAN */
                      ListTile(
                        leading: Icon(
                          Icons.settings_outlined,
                          color: Warna.Secondary,
                          size: 24,
                        ),
                        title: Text(
                          'Pengaturan'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'URW',
                              fontSize: screenHeight * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      ),
                      /* PENGATURAN */
                      /* LOGOUT */
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Warna.Secondary,
                          size: 24,
                        ),
                        title: Text(
                          'LOGOUT'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'URW',
                              fontSize: screenHeight * 0.021,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                      /* LOGOUT */
                    ],
                  ),
                ),
              ),
            ),

            // Add more ListTiles for other menu items as needed

            Divider(),
            // Footer item
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    'v Beta 0.0.1',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Handle footer item tap
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} /* SIDEBAR */

/* SHIMMER SKELETON */
class ShimmerAbu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerPutih extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white!,
          highlightColor: Colors.white24!,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.white,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
/* SHIMMER SKELETON */

/* Widget Rekomendasi Merchant */
class WidgetRecommend_Merchant extends StatelessWidget {
  final Map<String, dynamic> products;

  WidgetRecommend_Merchant({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  '${products['Product'][index]['ImageUrl']}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${products['Product'][index]['Product_Name']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'URW',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Warna.TextBold),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.store,
                              size: 16,
                              color: Warna.TextNormal,
                            ),
                            Text(
                              '${products['Product'][index]['Merchant_ID']}',
                              style: TextStyle(color: Warna.TextNormal),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            'Rp.${products['Product'][index]['Price']}',
                            style: TextStyle(
                                fontFamily: 'URW',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Warna.Primary),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
/* Widget Rekomendasi Merchant */

/* CONFIRMATION DIALOG LOGOUT */
class LogoutConfirmationDialog extends StatelessWidget {
  final Function onLogout;

  LogoutConfirmationDialog({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Konfirmasi Logout'.toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'URW',
                    fontWeight: FontWeight.bold)),
            Divider(),
            Text(
              'Apakah anda yakin ingin keluar dari akun ini?',
              style: TextStyle(fontFamily: 'URW', fontSize: 16),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Warna.TextNormal)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Batal'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(Warna.Secondary),
                      backgroundColor: MaterialStatePropertyAll(Warna.Primary)),
                  onPressed: () {
                    onLogout(); // Call the logout function
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* CONFIRMATION DIALOG LOGOUT */

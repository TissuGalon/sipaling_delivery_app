import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/keranjang.dart';
import 'package:mydelivery/merchant_page.dart';
import 'package:mydelivery/pencarian.dart';
import 'package:mydelivery/product.dart';
import 'package:mydelivery/profil_detail.dart';
import 'package:mydelivery/rupiah_format.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:mydelivery/warna.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/* CEK KONEKSI */
Future<bool> isDeviceOffline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.none;
}
/* CEK KONEKSI */

/* CLASS MERCHANT */

/* CLASS MERCHANT */
class Merchant {
  final String Merchant_ID;
  final String Merchant_Name;
  final String Description;
  final String Address;
  final String Coordinate;
  final String imageUrl;

  Merchant({
    required this.Merchant_ID,
    required this.Merchant_Name,
    required this.Description,
    required this.Address,
    required this.Coordinate,
    required this.imageUrl,
  });
}

/* CLASS PRODUK */
class Product {
  final String Merchant_ID;
  final String Product_ID;
  final String Product_Name;
  final String Description;
  final String ImageUrl;
  final String Price;
  final String Category_ID;

  Product({
    required this.Merchant_ID,
    required this.Product_ID,
    required this.Product_Name,
    required this.Description,
    required this.ImageUrl,
    required this.Price, // Initialize the price property
    required this.Category_ID, // Initialize the price property
  });
}
/* CLASS PRODUK */

class PageFood extends StatefulWidget {
  @override
  _PageFoodScreenState createState() => _PageFoodScreenState();
}

class _PageFoodScreenState extends State<PageFood> {
  /* FITUR */
  final List<Map<String, dynamic>> fitur = [
    {
      'gambar': 'assets/icon/nearest.png',
      'title': 'TERDEKAT',
      'route': '/terdekat',
    },
    {
      'gambar': 'assets/icon/discount.png',
      'title': 'DISKON',
      'route': '/diskon',
    },
    {
      'gambar': 'assets/icon/new.png',
      'title': 'TERBARU',
      'route': '/terbaru',
    },
    {
      'gambar': 'assets/icon/best_food.png',
      'title': 'TERBAIK',
      'route': '/terbaik',
    },
    {
      'gambar': 'assets/icon/history.png',
      'title': 'HISTORY',
      'route': '/history',
    },
    // Add more features as needed
  ];
  /* FITUR */

  /* ANEKA KUINER */
  final List<Map<String, dynamic>> kuliner = [
    {
      'gambar': 'assets/icon/nearest.png',
      'title': 'ALL KULINER',
      'route': '/terdekat',
    },
    {
      'gambar': 'assets/icon/discount.png',
      'title': 'JAJANAN',
      'route': '/diskon',
    },
    {
      'gambar': 'assets/icon/new.png',
      'title': 'CEPAT SAJI',
      'route': '/terbaru',
    },
    {
      'gambar': 'assets/icon/new.png',
      'title': 'ROTI & KUE',
      'route': '/terbaru',
    },
    {
      'gambar': 'assets/icon/best_food.png',
      'title': 'ANEKA NASI',
      'route': '/terbaik',
    },
    {
      'gambar': 'assets/icon/history.png',
      'title': 'AYAM & DAGING',
      'route': '/history',
    },
    // Add more features as needed
  ];
  /* ANEKA KUINER */

  List<Product> productList = [];
  List<Merchant> merchantList = [];
  bool isLoading = true;
  bool isLoadingRekomendasi = true;

  @override
  void initState() {
    super.initState();
    ambilDataMerchant();
    ambilDataDariAPI();
  }

  /* GET DATA RANDOM PRODUK */
  Future<void> ambilDataDariAPI() async {
    Map<String, dynamic> data =
        await fetchDataAPI('all/all_products.php?random=true');

    List<Product> products = []; // Create an empty list

    // Assuming data['Products'] is a list of products
    for (var productData in data['Product']) {
      products.add(Product(
        Merchant_ID: productData['Merchant_ID'],
        Product_ID: productData['Product_ID'],
        Product_Name: productData['Product_Name'],
        Description: productData['Description'],
        ImageUrl: productData['ImageUrl'],
        Price: productData['Price'],
        Category_ID: productData['Category_ID'],
      ));
    }

    setState(() {
      productList = products;
      isLoading = false;
    });
  }

  /* Future<void> ambilDataDariAPI() async {
    final response = await http.get(
      Uri.parse(
          'https://maxappid.com/api_sipaling/all/all_products.php?random=true'), // Replace with your API endpoint
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Product> products = responseData.map((data) {
        return Product(
          Product_Name: data['Product']['Product_Name'],
          description: data['Product']['Description'],
          imageUrl: data['Product']['ImageUrl'],
          price: double.parse(data['Product']['Price']),
        );
      }).toList();

      setState(() {
        productList = products;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  } */
  /* GET DATA RANDOM PRODUK */

  /* GET DATA MERCHANT */
  Future<void> ambilDataMerchant() async {
    Map<String, dynamic> data =
        await fetchDataAPI('all/all_merchant_products.php?random=true');

    List<Merchant> merchants = []; // Create an empty list

    // Assuming data['Merchant'] is a list of merchants
    for (var merchantData in data['Merchant']) {
      merchants.add(Merchant(
        Merchant_ID: merchantData['Merchant_ID'],
        Merchant_Name: merchantData['Merchant_Name'],
        Description: merchantData['Description'],
        imageUrl: merchantData['ImageUrl'],
        Address: merchantData['Address'],
        Coordinate: merchantData['Coordinate'],
      ));
    }

    setState(() {
      merchantList = merchants;
      isLoadingRekomendasi = false;
      isLoading = false;
    });
  }

  /*  Future<void> ambilDataMerchant() async {
    final response = await http.get(
      Uri.parse(
          'https://maxappid.com/api_sipaling/all/all_merchant.php'), // Replace with your API endpoint
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<Merchant> merchants = responseData.map((data) {
        return Merchant(
          Merchant_ID: data['Merchant_ID'],
          Merchant_Name: data['Merchant_Name'],
          Description: data['Description'],
          imageUrl: data['ImageUrl'],
          Address: data['Address'],
          Coordinate: data['Coordinate'],
          Account_ID: data['Account_ID'],
        );
      }).toList();

      setState(() {
        merchantList = merchants;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  } */
  /* GET DATA MERCHANT */

  @override
  Widget build(BuildContext context) {
    /* DESTINASI MENU*/
    void navigateToDestination(String route) {
      Navigator.pushNamed(context, route);
    }
    /* DESTINASI MENU*/

    return Scaffold(
      backgroundColor: Colors.white,
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
          'SIPALING FOOD',
          style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KeranjangPage()));
              },
              icon: Icon(Icons.shopping_cart_outlined),
              style: ButtonStyle(
                  iconColor: MaterialStatePropertyAll(Warna.Primary)),
              label: Text(''))
        ],
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            /* BANNER */
            Container(
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Adjust the radius as needed
                child: Image.network(
                  'https://lelogama.go-jek.com/cms_editor/2021/04/14/top-banner-1-ID.jpg',
                ),
              ),
            ),
            /* BANNER */

            /* SEARCH */
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1), // Add border decoration
                borderRadius: BorderRadius.circular(10), // Add border radius
              ),
              child: TextButton.icon(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => pencarian())),
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  // Set width and height
                  backgroundColor: MaterialStateProperty.all(
                      Colors.grey.shade50), // Background color
                ),
                icon: const Icon(
                  Icons.search,
                  color: Colors.black54,
                ),
                label: Text(
                  'Cari layanan, makanan, & tujuan',
                  style: TextStyle(color: Warna.TextNormal),
                ),
              ),
            ),
            /* SEARCH */

            SizedBox(
              height: 10,
            ),

            /* MENU FITUR */
            Container(
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: fitur.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToDestination(fitur[index]['route']);
                      },
                      child: Container(
                        width: 90, // Adjust the width as needed
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(fitur[index]['gambar'],
                                width: 60, height: 60),
                            SizedBox(height: 8),
                            Text(
                              fitur[index]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'URW',
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            /* MENU FITUR */

            //REKOMENDASI
            //TITLE
            Container(
              margin: EdgeInsets.only(top: 10, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REKOMENDASI TOKO',
                    style: TextStyle(
                        color: Warna.TextBold,
                        fontFamily: 'URW',
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProfilDetail())),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all<Color>(Warna.PrimaryHalf),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Mengatur agar Row mengambil lebar minimum
                      children: [
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: Warna
                                .Primary, // Warna teks tombol saat tombol tidak ditekan
                          ),
                        ),
                        Icon(
                          Icons.arrow_circle_right,
                          color: Warna
                              .Primary, // Warna ikon saat tombol tidak ditekan
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //TITLE
            //ISI

            isLoadingRekomendasi
                ? Container(
                    height: 180,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: merchantList.length,
                        itemBuilder: (context, index) {
                          return //ITEM REKOMENDASI
                              Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors
                                        .white, // You can set any color here
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: 80,
                                  height: 16,
                                  color: Colors
                                      .white, // You can set any color here
                                ),
                              ],
                            ),
                          );
                          //ITEM REKOMENDASI
                        },
                      ),
                    ),
                  )
                : Container(
                    height: 180,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: merchantList.length,
                        itemBuilder: (context, index) {
                          return
                              //ITEM REKOMENDASI
                              TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 252, 237, 241)),
                            ),
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => MerchantPage(
                                          Merchant_Id:
                                              merchantList[index].Merchant_ID,
                                        ))),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      merchantList[index].imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.store,
                                          size: 15,
                                          color: Warna.Primary,
                                        ),
                                        Text(
                                          merchantList[index]
                                              .Merchant_Name
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'URW',
                                              color: Warna.TextBold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          );
                          //ITEM REKOMENDASI
                        }),
                  ),
            //ISI
            //REKOMENDASI

            SizedBox(
              height: 5,
            ),

            //ANEKA KULINER

            //KULINER TITLE
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EKSPLOR ANEKA KULINER',
                    style: TextStyle(
                        color: Warna.TextBold,
                        fontFamily: 'URW',
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            //KULINER TITLE

            //ITEM KULINER
            Container(
              height: 130,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return //ITEM PILIHAN
                        TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 252, 237, 241)),
                      ),
                      onPressed: () {},
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(18, 250, 39, 92),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Color.fromARGB(58, 39, 250, 197))),
                            child: Image.asset(
                              kuliner[index]['gambar'],
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              kuliner[index]['title'],
                              style: TextStyle(
                                  fontFamily: 'URW', color: Warna.TextBold),
                            ),
                          )
                        ],
                      ),
                    );
                    //ITEM PILIHAN
                  }),
            ),
            //ITEM KULINER

            //ANEKA KULINER

            SizedBox(
              height: 10,
            ),

            /* RANDOM PRODUK */

            isLoading
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Display 2 products per row
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ShimmerProductCard();
                    },
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Display 2 products per row
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: productList[index]);
                    },
                  ),

            /* RANDOM PRODUK */
          ],
        ),
      ),
    );
  }
}

/* UI CARD */
class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      /* color: Color.fromARGB(18, 250, 39, 92), */
      color: Color.fromARGB(8, 250, 39, 92),
      elevation: 0,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 252, 237, 241)),
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MerchantPage(
                  Merchant_Id: product.Merchant_ID,
                ))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.ImageUrl,
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      product.Product_Name,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'URW',
                          color: Warna.TextBold,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      formatRupiah(double.parse(product.Price)),
                      style: TextStyle(
                          fontFamily: 'URW',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Warna.Primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                /* SUKAI */
                GestureDetector(
                  onTap: () {
                    print('LIKED');
                  },
                  child: Icon(
                    Icons.favorite_outline,
                    color: Warna.Primary,
                  ),
                ),
                /* SUKAI */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/* UI CARD */

/* UI CARD SKELETON */
class ShimmerProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(18, 250, 39, 92),
      elevation: 0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Customize base color
        highlightColor: Colors.grey[100]!, // Customize highlight color
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 130,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    width: 120,
                    height: 18,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    width: 80,
                    height: 20,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/* UI CARD SKELETON */


import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/checkout_food.dart';
import 'package:mydelivery/rupiah_format.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:mydelivery/warna.dart';

import 'package:image_picker/image_picker.dart';

class Product {
  final String productID;
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  Product({
    required this.productID,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}

List<Product> cartProducts = [];

class KeranjangPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<KeranjangPage> {
  List<Product> cartProducts = [];
  bool isLoading = true;
  double totalharga = 0.0;

  /*  Future<void> fetchCartProducts() async {
    final response = await http.get(
        Uri.parse('https://maxappid.com/api_sipaling/all/all_product.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      cartProducts = data
          .map((item) => Product(item['Product_ID'], item['Product_Name'],
              double.parse(item['Price']), item['ImageUrl'], 0))
          .toList();
      setState(() {
        isLoading = false;
        /* TOTAL HARGA */
        totalharga =
            data.fold(0.0, (sum, item) => sum + double.parse(item['Price']));
        /* TOTAL HARGA */
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  } */

  Future<void> fetchCartProducts() async {
    Map<String, dynamic> data =
        await fetchDataAPI('all/all_products.php?random=true');

    if (data['Product'] != null) {
      List<Product> products = data['Product']
          .map<Product>((item) => Product(
              productID: item['Product_ID'],
              productName: item['Product_Name'],
              price: double.parse(item['Price']),
              imageUrl: item['ImageUrl'],
              quantity: 0))
          .toList();

      setState(() {
        cartProducts = products;
        isLoading = false;

        /* TOTAL HARGA */
        totalharga = cartProducts.fold(
            0.0, (sum, product) => sum + (product.price * product.quantity));
        /* TOTAL HARGA */
      });
    } else {
      // Handle the case where data['Products'] is null or empty
      print("No products data found in API response");
    }
  }

  @override
  void initState() {
    fetchCartProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.BG,
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
        title: const Text(
          'KERANJANG SAYA',
          style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Center(
              child: Row(
            children: [
              Text(
                cartProducts.length.toString(),
                style: TextStyle(
                    color: Warna.Primary,
                    fontFamily: 'URW',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'ITEM',
                style: TextStyle(
                    color: Color(0xFF222222),
                    fontFamily: 'URW',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                formatRupiah(totalharga),
                style: TextStyle(
                    color: Warna.Primary,
                    fontFamily: 'URW',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                width: 7,
              ),
            ],
          ))
        ],
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: isLoading
          ? ListView.builder(
              itemCount: 6, // Show a few shimmer skeletons
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 2, left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: ListTile(
                      title: Container(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      subtitle: Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 2, left: 5, right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                    leading: Container(
                      height: double.infinity,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          cartProducts[index].imageUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    title: Text(
                      cartProducts[index].productName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      formatRupiah(cartProducts[index].price),
                      style: TextStyle(
                          color: Warna.Primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          splashColor: Warna.Secondary,
                          color: Warna.Primary,
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (cartProducts[index].quantity > 0) {
                                cartProducts[index].quantity--;
                              }
                            });
                          },
                        ),
                        Text(
                          cartProducts[index].quantity.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          splashColor: Warna.Secondary,
                          color: Warna.Primary,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              cartProducts[index].quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      /* FLOATING BUTTON */
      floatingActionButton: FloatingActionButton(
        splashColor: Warna.Secondary,
        backgroundColor: Warna.Primary,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CheckoutFoodPage(koordinatReceiver: '')));
        },
        child: const Icon(Icons.shopping_cart_checkout_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      /* FLOATING BUTTON */
    );
  }
}

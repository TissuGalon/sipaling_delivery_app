import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydelivery/warna.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final String thumbnail;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.thumbnail});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'].toString(),
      price: json['price'].toString(),
      thumbnail: json['thumbnail'].toString(),
    );
  }
}

class NgambilDataProduk {
  final String apiUrl;

  NgambilDataProduk(this.apiUrl);

  Future<List<Product>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));

    print('Response Body: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData is List) {
        final List<Product> products =
            jsonData.map((data) => Product.fromJson(data)).toList();
        return products;
      } else if (jsonData is Map) {
        if (jsonData.containsKey('products')) {
          final List<Product> products = (jsonData['products'] as List)
              .map((data) => Product.fromJson(data))
              .toList();
          return products;
        } else {
          throw Exception('Key "products" not found in JSON map');
        }
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}

void main() {
  runApp(TestTampil());
}

class TestTampil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final NgambilDataProduk dataProduk =
      NgambilDataProduk('https://dummyjson.com/products');

  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = dataProduk.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No products available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return //ITEM TRANSAKSI
                    Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {},
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                '${product.thumbnail}',
                                width: 80,
                                height: 80,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.name}',
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
                                        'MacDonalds',
                                        style:
                                            TextStyle(color: Warna.TextNormal),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'USD ${product.price}',
                                    style: TextStyle(
                                        fontFamily: 'URW',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Warna.Primary),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '2 Agustus 2023',
                                style: TextStyle(
                                    fontFamily: 'URW',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade600),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Warna.Primary),
                                  ),
                                  child: Text(
                                    'Beli Lagi',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'URW',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
                //ITEM TRANSAKSI
              },
            );
          }
        },
      ),
    );
  }
}

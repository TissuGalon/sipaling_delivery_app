import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';

class Productnih {
  final String Product_ID;
  final String Product_Name;
  final String Description;
  final double Price;
  final String Category_ID;
  final String Merchant_ID;
  final String Date_Added;
  final String ImageUrl;
  final String isEmpty;

  Productnih({
    required this.Product_ID,
    required this.Product_Name,
    required this.Description,
    required this.Price,
    required this.Category_ID,
    required this.Merchant_ID,
    required this.Date_Added,
    required this.ImageUrl,
    required this.isEmpty,
  });

  factory Productnih.fromJson(Map<String, dynamic> json) {
    return Productnih(
      Product_ID: json['Product_ID'].toString(),
      Product_Name: json['Product_Name'].toString(),
      Description: json['Description'].toString(),
      Price: double.parse(json['Price']),
      Category_ID: json['Category_ID'].toString(),
      Merchant_ID: json['Merchant_ID'].toString(),
      Date_Added: json['Date_Added'],
      ImageUrl: json['ImageUrl'].toString(),
      isEmpty: json['isEmpty'].toString(),
    );
  }
}

class ProductService {
  final String apiUrl;

  ProductService(this.apiUrl);

  Future<List<Productnih>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Productnih.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}

/* Widget Riwayat Transaksi */

class WidgetRiwayatTransaksi extends StatelessWidget {
  final List<Productnih> products;

  WidgetRiwayatTransaksi({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        /* ITEM */
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: TextButton(
            onPressed: () {},
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          '${products[index].ImageUrl}',
                          fit: BoxFit.fitWidth,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${products[index].Product_Name}',
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
                                '${products[index].Merchant_ID}',
                                style: TextStyle(color: Warna.TextNormal),
                              ),
                            ],
                          ),
                          Text(
                            'Rp. ${products[index].Price}',
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
                        '${products[index].Date_Added}',
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
        /* ITEM */
      },
    );
  }
}
/* Widget Riwayat Transaksi */



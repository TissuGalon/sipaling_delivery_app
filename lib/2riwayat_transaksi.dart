import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:mydelivery/warna.dart';

class TransactionItem {
  final String Product_ID;
  final String Product_Name;
  final String Description;
  final double Price;
  final String Category_ID;
  final String Merchant_ID;
  final String Date_Added;
  final String ImageUrl;
  final String isEmpty;

  TransactionItem({
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
}

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionItem> transactionItems = [];

  Future<void> fetchTransactionData() async {
    final response = await http.get(
        Uri.parse('https://maxappid.com/api_sipaling/all/all_product.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body);
      setState(() {
        transactionItems = parseTransactionData(data);
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  List<TransactionItem> parseTransactionData(dynamic data) {
    List<TransactionItem> items = [];
    for (var itemData in data) {
      items.add(TransactionItem(
        Product_ID: itemData['Product_ID'],
        Product_Name: itemData['Product_Name'],
        Description: itemData['Description'],
        Price: double.parse(itemData['Price']),
        Category_ID: itemData['Category_ID'],
        Merchant_ID: itemData['Merchant_ID'],
        Date_Added: itemData['Date_Added'],
        ImageUrl: itemData['ImageUrl'],
        isEmpty: itemData['isEmpty'],
      ));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ListView.builder(
        itemCount: transactionItems.length,
        itemBuilder: (context, index) {
          return buildTransactionItem(transactionItems[index]);
        },
      ),
    );
  }

/* SHIMMER SKELETON */
  Widget _buildLoadingSkeletons() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer skeletons
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 150,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 100,
                        height: 15,
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
/* SHIMMER SKELETON */

  Widget buildTransactionItem(TransactionItem item) {
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
                  Image.network(
                    'https://nos.jkt-1.neo.id/mcdonalds/foods/October2019/9FcgMqqWSFYjE6edaOAL.png',
                    width: 80,
                    height: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.Product_Name,
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
                            item.Product_Name,
                            style: TextStyle(color: Warna.TextNormal),
                          ),
                        ],
                      ),
                      Text(
                        'Rp. ${item.Price.toStringAsFixed(2)}',
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
                    item.Date_Added,
                    style: TextStyle(
                        fontFamily: 'URW',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Warna.Primary),
                    ),
                    child: Text(
                      'Beli Lagi',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'URW',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TransactionHistoryScreen()));
}

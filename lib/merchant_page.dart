// product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/keranjang.dart';
import 'package:mydelivery/pembuka_url.dart';
import 'package:mydelivery/rupiah_format.dart';
import 'package:mydelivery/warna.dart';
import 'package:shimmer/shimmer.dart';

import 'package:badges/badges.dart' as badges;

/* CLASS PRODUK */

/* CLASS PRODUK */

class MerchantPage extends StatefulWidget {
  final String Merchant_Id;

  MerchantPage({required this.Merchant_Id});
  bool isLoading = true;

  @override
  _MerchantPageScreenState createState() => _MerchantPageScreenState();
}

class _MerchantPageScreenState extends State<MerchantPage> {
  bool isLoading = true;

  /* GET DATA PRODUK MERCHANT */
  List<Map<String, dynamic>> productList = [];

  String merchantId = '';
  String merchantName = '';
  String description = '';
  String address = '';
  String coordinate = '';
  String imageUrl = '';

  Future<void> fetchData(String idmerchant) async {
    try {
      final responseData = await fetchDataAPI(
          'all/all_merchant_products.php?Merchant_ID=$idmerchant');

      final List<dynamic> merchantData = responseData['Merchant'];
      final Map<String, dynamic> merchant = merchantData[0];
      final List<dynamic> productData = merchant['Product'];

      /* Merchant Data */
      merchantId = merchant['Merchant_ID'];
      merchantName = merchant['Merchant_Name'];
      description = merchant['Description'];
      address = merchant['Address'];
      coordinate = merchant['Coordinate'];
      imageUrl = merchant['ImageUrl'];
      /* Merchant Data */

      setState(() {
        Map<String, dynamic> DataMerchant = merchantData[0];
        productList = List<Map<String, dynamic>>.from(productData);
        isLoading = false;
      });
    } catch (error) {
      // Handle error here
    }
  }
  /* GET DATA PRODUK MERCHANT */

  void get_jumllah_cart() {}

  @override
  void initState() {
    super.initState();
    String merchantId = widget.Merchant_Id;
    fetchData(merchantId);
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
            color: Colors.black,
          ),
        ),
        title: Text(
          'MERCHANT PAGE',
          style: TextStyle(
              color: Colors.black,
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
      body: isLoading
          ? CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildSkeletonHeader(),
                      _buildSkeletonCard(),
                      _buildSkeletonProductList(),
                    ],
                  ),
                ),
              ],
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 150,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                    collapseMode: CollapseMode.parallax,
                    centerTitle: true,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Card(
                        color: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(height: 16),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        merchantName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'URW',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${address},${coordinate}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'URW',
                                                color: Warna.TextNormal),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=$coordinate');
                                try {
                                  await Pembuka_Url.launchUrl(url,
                                      mode: ModeLaunch.external);
                                } catch (e) {
                                  print('Error: $e');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors
                                    .white), // Set background color to white
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Warna.Primary)), // Set border color
                                overlayColor:
                                    MaterialStatePropertyAll(Warna.Secondary),

                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                minimumSize: MaterialStateProperty.all(
                                    Size(50, 50)), // Set minimum button size
                                maximumSize: MaterialStateProperty.all(
                                    Size(100, 100)), // Set maximum button size
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set the border radius here
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.location_pin,
                                color: Warna
                                    .Primary, // Set the icon color to Warna.Primary
                              ),
                              label: Text(''),
                            ),
                          ],
                        ),
                      ),

                      /* PRODUCT LIST */
                      Card(
                        color: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = productList[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Container(
                                    width: double.infinity,
                                    /* padding: EdgeInsets.only(5), */
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled:
                                              true, // Makes the sheet full-screen
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor:
                                                  0.5, // Adjust as needed
                                              child: ProductDetailWidget(
                                                  product: product),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              badges.Badge(
                                                badgeAnimation: badges
                                                    .BadgeAnimation.scale(),
                                                badgeContent: Icon(
                                                  Icons.local_offer,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                badgeStyle: badges.BadgeStyle(
                                                    badgeColor: Warna.Primary),
                                                position: badges.BadgePosition
                                                    .topStart(),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    product['ImageUrl'],
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product['Product_Name'],
                                                    style: TextStyle(
                                                        fontFamily: 'URW',
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Warna.TextBold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    formatRupiah(double.parse(
                                                        product['Price'])),
                                                    style: TextStyle(
                                                        fontFamily: 'URW',
                                                        fontSize: 15,
                                                        color: Warna.TextBold),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              TextButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        MaterialStatePropertyAll(
                                                            Warna.Secondary),
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Warna.Primary),
                                                  ),
                                                  child: Text(
                                                    'PESAN',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'URW',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          },
                        ),
                      ),
                      /* PRODUCT LIST */

                      // Add more profile details here
                      // For example, bio, interests, posts, etc.
                      // Extra space for demonstration
                      /* SizedBox(height: 300), */
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/* PRODUCT POP UP DETAIL */
class ProductDetailWidget extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailWidget({required this.product});

  @override
  _ProductDetailWidgetState createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  bool isFavorite = false; // To track the favorite state
  int likeCount = 42; // Ganti dengan jumlah like yang sesuai

  @override
  Widget build(BuildContext context) {
    return Container(
      /* padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0), */
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* IMAGE */
          badges.Badge(
            badgeAnimation: badges.BadgeAnimation.scale(),
            badgeContent: Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 15,
            ),
            badgeStyle: badges.BadgeStyle(badgeColor: Warna.Primary),
            position: badges.BadgePosition.topStart(),
            child: Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product['ImageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /* IMAGE */
          Text(widget.product['Product_Name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            formatRupiah(double.parse(widget.product['Price'])),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Warna.TextBold),
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate quia necessitatibus minima magnam iste, dolor voluptates! Non itaque dignissimos recusandae tempora necessitatibus blanditiis perferendis est numquam beatae, consequatur veritatis hic.',
            style: TextStyle(fontFamily: 'URW'),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          /* LIKED */
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex:
                      2, // Adjust the flex value as needed to make the button longer
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Warna.Secondary),
                      backgroundColor: MaterialStateProperty.all(Warna.Primary),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'PESAN',
                      style: TextStyle(
                        fontFamily: 'URW',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1, // Adjust the flex value as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite =
                                !isFavorite; // Toggle the favorite state
                            if (isFavorite) {
                              likeCount++;
                            } else {
                              likeCount--;
                            }
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                      Text(
                        likeCount.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /* LIKED */
        ],
      ),
    );
  }
}

/* PRODUCT POP UP DETAIL */

/* SHIMMER SKELETON */
Widget _buildSkeletonHeader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      color: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 100,
                    color: Colors.grey[300],
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

Widget _buildSkeletonCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      color: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 12,
                    color: Colors.grey[300],
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

Widget _buildSkeletonProductList() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Card(
      color: Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(10),
      child: Column(
        children: List.generate(
          5,
          (index) => ListTile(
            title: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/* SHIMMER SKELETON */
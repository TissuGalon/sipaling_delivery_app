import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mydelivery/call_api.dart';
import 'package:mydelivery/keranjang.dart';
import 'package:mydelivery/rupiah_format.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:mydelivery/warna.dart';
import 'package:mydelivery/location_picker.dart';
import 'package:mydelivery/pembuka_url.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

/* MAP */
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
/* MAP */

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

class CheckoutFoodPage extends StatefulWidget {
  final String koordinatReceiver;
  CheckoutFoodPage({required this.koordinatReceiver});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutFoodPage> {
  List<Product> cartProducts = [];
  double totalharga = 0.0;
  int totalitem = 0;
  double ongkir = 0.0;
  double total = 0.0;
  late String selectedLatLng;
  String gpslat = '';
  String gpslng = '';
  String koordinatgps = '';
  String alamatgps = '';

  /* LOADING VAR */
  bool isLoading = true;
  bool isLoadingAddress = true;
  bool isLoadingPrice = true;
  bool isLoadingDistance = true;
  /* LOADING VAR */

  /* CEK STRING KOSONG */
  bool isBlank(String value) {
    return value.trim().isEmpty;
  }
  /* CEK STRING KOSONG */

  /* AKSES LOKASAI */
  loc.Location _location = loc.Location();
  bool _serviceEnabled = false;
  perm.PermissionStatus _permissionGranted = perm.PermissionStatus.denied;
  late loc.LocationData _locationData;
  /* AKSES LOKASAI */

  /* VOUCHER */
  String _selectedVoucher = 'Voucher A';

  final List<String> _vouchers = [
    'Voucher A',
    'Voucher B',
    'Voucher C',
    'Voucher D',
  ];
  /* VOUCHER */

  /* PEMBAYARAN */
  String _selectedPayment = '';

  /* WIDGET PEMBAYARAN */
  Widget _buttonPembayaran(String paymentType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedPayment = paymentType;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedPayment == paymentType ? Warna.Primary : Warna.BG,
          foregroundColor:
              _selectedPayment == paymentType ? Colors.white : Warna.Primary,
          // Change color based on selection
        ),
        child: Text(paymentType),
      ),
    );
  }
  /* WIDGET PEMBAYARAN */
  /* PEMBAYARAN */

  /* MINTA AKSES LOKASI */
  Future<void> _checkLocationPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        _AlertDenied(context);
        // Handle case when location service is not enabled
        return;
      }
    }

    _permissionGranted = await perm.Permission.location.status;

    if (_permissionGranted.isDenied) {
      _permissionGranted = await perm.Permission.location.request();
      if (_permissionGranted.isDenied) {
        _AlertDenied(context);
        // Handle case when location permission is not granted

        return;
      }
    }
    _getLocation();
  }

  Future<void> _getLocation() async {
    _locationData = await _location.getLocation();

    setState(() {
      String temp =
          '${_locationData.latitude.toString()}, ${_locationData.longitude.toString()}';
      koordinatgps = temp;
      gpslat = _locationData.latitude.toString();
      gpslng = _locationData.longitude.toString();
    });

    if (isBlank(selectedLatLng)) {
      if (_locationData.latitude != null && _locationData.longitude != null) {
        // Memanggil fungsi getAddressFromLatLng dengan koordinat yang diperoleh
        String address = await getAddressFromLatLng(
            _locationData.latitude!, _locationData.longitude!);

        setState(() {
          alamatgps = address;
        });
      } else {
        setState(() {
          alamatgps = 'Address not available';
        });
      }
    } else {
      /* UBAH STRING KE DOUBLE */
      List<double> doubleValues = selectedLatLng
          .split(', ')
          .map((value) => double.parse(value))
          .toList();
      /* UBAH STRING KE DOUBLE */

      String address =
          await getAddressFromLatLng(doubleValues[0], doubleValues[1]);
      setState(() {
        alamatgps = address;
      });
    }
    isLoadingAddress = false;
  }

  /* MINTA AKSES LOKASI */

  /* GET ADDRESS DARI KOORDINAT*/

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    final url = 'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final results = data['display_name'];

      if (results.isNotEmpty) {
        return results;
      }
    }

    return ''; // Return an empty string if address retrieval fails
  }

  // FUNGSI JALANIN GETADDRESS
  /*  final address = await getAddressFromLatLng(
                    latLng.latitude, latLng.longitude);
                setState(() {
                  selectedAddress = address;
                }); */
  // FUNGSI JALANIN GETADDRESS

  /* GET ADDRESS DARI KOORDINAT*/

  Future<void> fetchCartProducts() async {
    Map<String, dynamic> data =
        await fetchDataAPI('all/all_products.php?random=true');

    if (data['Product'] != null) {
      List<Product> products = List<Product>.from(data['Product'].map(
        (item) => Product(
          productID: item['Product_ID'],
          productName: item['Product_Name'],
          price: double.parse(item['Price']),
          imageUrl: item['ImageUrl'],
          quantity: 3, // You can set the initial quantity here
        ),
      ));

      setState(() {
        cartProducts = products;
        isLoading = false;

        /* TOTAL HARGA ITEM */
        totalharga = cartProducts.fold(
            0.0, (sum, product) => sum + (product.price * product.quantity));
        /* TOTAL HARGA ITEM */

        totalitem = cartProducts.length; // Set the total item count

        /* SET TOTAL */
        total = totalharga + ongkir; // Assuming ongkir is defined elsewhere
        /* SET TOTAL */
      });
    } else {
      // Handle the case where data['Product'] is null or empty
      print("No products data found in API response");
    }
  }

  @override
  void initState() {
    ReloadAll();
    super.initState();
    selectedLatLng = widget.koordinatReceiver;
    /* SET ONGKIR */
    ongkir = 16000;
    /* SET ONGKIR */
  }

  /* RELOAD ALL */
  void ReloadAll() {
    isLoading = true;
    isLoadingAddress = true;
    fetchCartProducts();

    _checkLocationPermissions();
  }
  /* RELOAD ALL */

  /* UBAH STRING KE LATLNG */
  LatLng SplitterLatLng(subject) {
    List<double> Hasil =
        subject.split(', ').map((value) => double.parse(value)).toList();

    return LatLng(Hasil[0], Hasil[1]);
  }
  /* UBAH STRING KE LATLNG */

  /* ALERT */
  void _AlertDenied(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "ALERT",
            style: TextStyle(fontFamily: 'URW', fontWeight: FontWeight.bold),
          ),
          content:
              Text("Hidupkan GPS dan Berikan izin lokasi untuk melanjutkan."),
          actions: [
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Warna.Primary)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        KeranjangPage(), // Ganti dengan halaman yang ingin Anda tuju
                  ),
                ); // Close the alert
              },
              child: Text(
                "OK",
              ),
            ),
          ],
        );
      },
    );
  }
  /* ALERT */

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
          'CHECKOUT',
          style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'PESANAN KAMU',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'URW'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
            ),

            /* LIST PRODUK */
            Container(
              width: double.infinity,
              height: 250,
              margin: EdgeInsets.only(top: 3, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: isLoading
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
            ),
            /* LIST PRODUK */

            /* ALAMAT */
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'ALAMAT',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'URW'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(),
                    /* ALAMAT MERCHANT */
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Warna.BG,
                          child: Image.network(
                            'https://images.getbento.com/accounts/4f241c36862f0ed0d6d1419a36576d4b/media/images/16858How-2-Smash-Eat-It-RGB.png?w=1200&fit=crop&auto=compress,format&crop=focalpoint&fp-x=0.5&fp-y=0.5',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Merchant',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Address',
                                overflow: TextOverflow.ellipsis,
                                maxLines:
                                    2, // Adjust the maxLines value as needed
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    /* ALAMAT MERCHANT */
                    SizedBox(
                      height: 20,
                    ),
                    /* ANTAR KE */

                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Antar ke Alamat :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              /* ALAMAT KOORDINAT*/
                              isLoadingAddress
                                  ? Shimmer.fromColors(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(right: 20, top: 5),
                                        height: 30,
                                        width: double.infinity,
                                        child: Container(
                                          height: 16,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                    )
                                  : isBlank(selectedLatLng)
                                      ? GestureDetector(
                                          onTap: () async {
                                            final url = Uri.parse(
                                                'https://www.google.com/maps/search/?api=1&query=$koordinatgps');
                                            try {
                                              await Pembuka_Url.launchUrl(url,
                                                  mode: ModeLaunch.external);
                                            } catch (e) {
                                              print('Error: $e');
                                            }
                                          },
                                          child: Text(
                                            '$alamatgps, $koordinatgps',
                                            style: TextStyle(
                                              color: Warna.Primary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                2, // Adjust the maxLines value as needed
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            final url = Uri.parse(
                                                'https://www.google.com/maps/search/?api=1&query=$selectedLatLng');
                                            try {
                                              await Pembuka_Url.launchUrl(url,
                                                  mode: ModeLaunch.external);
                                            } catch (e) {
                                              print('Error: $e');
                                            }
                                          },
                                          child: Text(
                                            '$alamatgps, $selectedLatLng',
                                            style: TextStyle(
                                              color: Warna.Primary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                2, // Adjust the maxLines value as needed
                                          ),
                                        )
                              /* ALAMAT KOORDINAT*/
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final hasil = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => picker_lokasi(
                                        koordinatReceiver: selectedLatLng,
                                      )),
                            );

                            if (hasil != null) {
                              setState(() {
                                isLoadingAddress = true;
                                selectedLatLng = hasil;
                                _getLocation();
                              });
                            }
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Warna.Secondary),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Warna.Primary),
                          ),
                          icon: Icon(
                            Icons.pin_drop_outlined,
                          ),
                          label: Text(''),
                        )
                      ],
                    ),
                    /* ANTAR KE */

                    SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    /* JARAK DAN WAKTU */
                    /* JARAK */
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Icon(Icons.timeline_rounded),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jarak',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '6,0 Km',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    /* JARAK */
                    /* WAKTU */
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Icon(Icons.timer_outlined),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waktu',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '10 menit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    /* WAKTU */
                    /* JARAK DAN WAKTU */

                    /* MAPS */

                    /* MAPS */
                  ]),
            ),
            /* ALAMAT */

            /* ESTIMASI BIAYA */
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'ESTIMASI BIAYA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'URW'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(),
                    /* HARGA MAKANAN */
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Icon(Icons.shopping_cart_outlined),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga Makanan ($totalitem Item)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : Text(
                                formatRupiah(totalharga),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                    /* HARGA MAKANAN */
                    SizedBox(
                      height: 5,
                    ),
                    /* HARGA ONGKIR */
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Icon(Icons.delivery_dining_outlined),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ongkos Kirim',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : Text(
                                formatRupiah(ongkir),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                    /* HARGA ONGKIR */
                    const Divider(),
                    /* TOTAL HARGA */
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(8),
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 90,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : Text(
                                formatRupiah(total),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Warna.Primary),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                    /* TOTAL HARGA */

                    TextButton(
                        onPressed: () {
                          ReloadAll();
                        },
                        child: Text('Reload'))
                  ]),
            ),
            /* ESTIMASI BIAYA */
            /* ESTIMASI BIAYA */
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'PENGIRIMAN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          fontFamily: 'URW'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(),
                    /* PESAN */
                    TextField(
                      maxLines: 3, // Adjust as needed
                      decoration: InputDecoration(
                        labelText: 'Tambahkan Pesan untuk Pengiriman . . .',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    /* PESAN */
                    /* VOUCHER */
                    /*  DropdownButton<String>(
                          value: _selectedVoucher,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedVoucher = newValue.toString();
                            });
                          },
                          items: _vouchers
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('Select a voucher'),
                        ), */
                    /* VOUCHER */

                    SizedBox(
                      height: 5,
                    ),

                    /* PEMBAYARAN */
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PILIH METODE PEMBAYARAN :',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buttonPembayaran('SALDO (Rp 100.000)'),
                            _buttonPembayaran(
                                'Uang Tunai / Cash'.toUpperCase()),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 16),
                        Container(
                            width: double.infinity,
                            child: SizedBox(
                              width: 200, // Adjust the width as needed
                              height: 60, // Adjust the height as needed
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    iconColor:
                                        MaterialStateProperty.all(Colors.white),
                                    overlayColor: MaterialStateProperty.all(
                                        Warna.Secondary),
                                    backgroundColor: MaterialStateProperty.all(
                                        Warna.Primary),
                                  ),
                                  onPressed: () {
                                    if (_selectedPayment.isNotEmpty) {
                                      // Process the selected payment
                                      print(
                                          'Selected payment: $_selectedPayment');
                                    }
                                  },
                                  child: Text(
                                    'PESAN SEKARANG (${formatRupiah(total)})',
                                    style: const TextStyle(
                                      fontFamily: 'URW',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    /* PEMBAYARAN */
                  ]),
            ),
            /* ESTIMASI BIAYA */
          ],
        ),
      ),

      /* FLOATING BUTTON */
      /* FLOATING BUTTON */
    );
  }
}

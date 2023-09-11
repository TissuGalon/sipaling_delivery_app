import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mydelivery/checkout_food.dart';
import 'package:mydelivery/warna.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class picker_lokasi extends StatefulWidget {
  final String koordinatReceiver;
  picker_lokasi({required this.koordinatReceiver});

  @override
  _Picker_LokasiState createState() => _Picker_LokasiState();
}

class _Picker_LokasiState extends State<picker_lokasi> {
  LatLng nowLatLng = LatLng(4.473855, 97.962586); // Default coordinates
  LatLng selectedLatLng = LatLng(4.473855, 97.962586); // Default coordinates
  bool LokasiUser = false;
  late LatLng cam;
  bool waitCam = true;

  /* CEK STRING KOSONG */
  bool isBlank(String value) {
    return value.trim().isEmpty;
  }
  /* CEK STRING KOSONG */

  /* GET LOKASI SEBELUMNYA */
  Future<void> _getLokasiSebelumnya() async {
    final latLngList =
        widget.koordinatReceiver.split(','); // Split the string into a list
    final double lat = double.parse(latLngList[0]); // Parse latitude
    final double lng = double.parse(latLngList[1]);
    selectedLatLng = LatLng(lat, lng);
    cam = LatLng(lat, lng);
    waitCam = false;
  }
  /* GET LOKASI SEBELUMNYA */

  /* GET LOKASI SEKARANG */
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle denied permission
    } else if (permission == LocationPermission.deniedForever) {
      // Handle denied permission permanently
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        LokasiUser = true;
        nowLatLng = LatLng(position.latitude, position.longitude);
        if (isBlank(widget.koordinatReceiver)) {
          selectedLatLng = LatLng(position.latitude, position.longitude);
          cam = LatLng(position.latitude, position.longitude);
          waitCam = false;
        }
      });
    }
  }
  /* GET LOKASI SEKARANG */

  @override
  void initState() {
    _getUserLocation();
    _getLokasiSebelumnya();
    super.initState();
  }

  /* CEK POSISI CAMERA */
  /* LatLng cams() {
    if (isBlank(widget.koordinatReceiver)) {
      if (LokasiUser) {
        return nowLatLng;
      } else {
        return const LatLng(4.473855, 97.962586);
      }
    } else {
      return selectedLatLng;
    }
  } */
  /* CEK POSISI CAMERA */

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
            color: Color(0xFF222222),
          ),
        ),
        title: const Text(
          'INPUT LOKASI',
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
      body: waitCam
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Warna.Primary),
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  /* PENGATURAN MAP */
                  options: MapOptions(
                    center: cam,
                    zoom: 18.4,
                    minZoom: 5.0,
                    maxZoom: 18.4,
                    onTap: (tapPosition, latLng) async {
                      setState(() {
                        selectedLatLng = latLng;
                      });
                    },
                  ),
                  /* PENGATURAN MAP */
                  children: [
                    /* SKIN MAP */

                    /* MAP SATELIT */
                    /* -------------------------------- */
                    /* TileLayer(
                urlTemplate:
                    "http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}",
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
              ), */
                    /* -------------------------------- */
                    /* MAP SATELIT */

                    /* MAP STREET */
                    TileLayer(
                      urlTemplate:
                          "http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    ),
                    /* MAP STREET */

                    /* SKIN MAP */

                    /* LOKASI USER */
                    LocationMarkerLayer(
                      position: LocationMarkerPosition(
                        latitude: nowLatLng.latitude,
                        longitude: nowLatLng.longitude,
                        accuracy: 100,
                      ),
                    ),

                    /* LOKASI USER */

                    /* PIN INPUT LOKASI */
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: selectedLatLng,
                          builder: (ctx) => Container(
                              // Replace the default Icon with your custom widget
                              child: Image.network(
                                  'https://www.freepnglogos.com/uploads/pin-png/file-map-pin-icon-green-svg-wikimedia-commons-39.png')
                              // Replace with your custom widget
                              ),
                        ),
                      ],
                    ),

                    /* PIN INPUT LOKASI */
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            'Latitude: ${selectedLatLng.latitude.toStringAsFixed(6)}\nLongitude: ${selectedLatLng.longitude.toStringAsFixed(6)}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 16),
                        /* TOMBOL PILIH LOKASI */
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0), // Add horizontal margins
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Warna.Primary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            /*   onPressed: () {
                        // Handle coordinate selection, e.g., pass selectedLatLng to another screen
                      }, */
                            onPressed: () => Navigator.pop(context,
                                "${selectedLatLng.latitude.toStringAsFixed(6)}, ${selectedLatLng.longitude.toStringAsFixed(6)}"),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'PILIH LOKASI INI',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                        /* TOMBOL PILIH LOKASI */
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

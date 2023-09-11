import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';

class pencarian extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<pencarian> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

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
        title: Text(
          'PENCARIAN',
          style: TextStyle(
              color: Color(0xFF222222),
              fontFamily: 'URW',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              textInputAction: TextInputAction
                  .search, // Menampilkan tombol pencarian di keyboard
              onSubmitted: (value) {
                // Callback yang akan dipanggil saat tombol pencarian ditekan pada keyboard
                // Di sinilah Anda dapat menambahkan logika untuk mengeksekusi pencarian
              },
              decoration: InputDecoration(
                labelText: 'Cari...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(), // Membuat fungsi ini di bawah
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // Di sini Anda dapat mengganti ini dengan daftar item yang ingin Anda cari.
    // Misalnya, daftar dari database atau API.
    List<String> data = [
      'Item 1',
      'Item 2',
      'Item 3',
      // Tambahkan item lainnya di sini.
    ];

    List<String> filteredData = data
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredData[index]),
        );
      },
    );
  }
}

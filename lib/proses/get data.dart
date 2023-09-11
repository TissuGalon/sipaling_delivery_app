import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_produk'],
      name: json['nama_produk'],
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
        // Handle map structure here
        throw Exception('Received JSON map, but list expected');
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}

void main() async {
  final dataproduk = NgambilDataProduk('https://dummyjson.com/products');

  try {
    final products = await dataproduk.fetchData();

    for (var product in products) {
      print('Product ID: ${product.id}, Nama Produk: ${product.name}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

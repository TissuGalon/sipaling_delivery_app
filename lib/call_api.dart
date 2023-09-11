import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchDataAPI(String path) async {
  String apiurl = alamatAPI();
  final response = await http.get(Uri.parse('$apiurl/$path'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON

    return json.decode(response.body);
  } else {
    // If that call was not successful, throw an error.z
    throw Exception('Failed to load data');
  }
}

String alamatAPI() {
  return 'https://maxappid.com/api_sipaling';
}

void main() async {
  Map<String, dynamic> data =
      await fetchDataAPI('all/all_merchant_products.php?random=true');

  print(data['Merchant'][0]['Merchant_Name']);
}

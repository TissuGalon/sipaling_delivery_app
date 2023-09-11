import 'package:url_launcher/url_launcher.dart';

class Pembuka_Url {
  static Future<void> launchUrl(Uri url,
      {ModeLaunch mode = ModeLaunch.external}) async {
    if (!await launch(
      url.toString(),
      forceSafariVC: false,
      forceWebView: false,
      enableJavaScript: true,
      enableDomStorage: true,
      universalLinksOnly: true,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

enum ModeLaunch {
  external,
  safariVC,
  webView,
  appScheme,
}

void main() async {
  final url = Uri.parse('https://www.example.com');
  try {
    await Pembuka_Url.launchUrl(url, mode: ModeLaunch.external);
  } catch (e) {
    print('Error: $e');
  }
}

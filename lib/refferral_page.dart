import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class referral_page extends StatefulWidget {
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<referral_page> {
  /* LIST LANGKAH */
  List<Map<String, dynamic>> langkah() {
    String jsonString = '''
  [
    {
      "judul": "Mulai mengundang",
      "isi": "Ajak temanmu untuk download aplikasi Sipaling Delivery"
    },
    {
      "judul": "Temanmu akan dapat voucher diskon 1x50%",
      "isi": "Setelah temanmu terdaftar sebagai pengguna di aplikasi Sipaling Delivery, voucher diskon ongkir 1x50% akan masuk ke akunnya."
    },
    {
      "judul": "Kamu akan mendapatkan voucher diskon 1x50%",
      "isi": "Voucher diskon ongkir 1x50% akan masuk ke akunmu setelah temanmu melakukan transaksi pertamanya di aplikasi Sipaling Delivery"
    }
  ]
  ''';

    List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(jsonDecode(jsonString));

    return data;
  }
  /* LIST LANGKAH */

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
          'REFERRAL',
          style: TextStyle(
            color: Color(0xFF222222),
            fontFamily: 'URW',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              /* BANNER */
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/referral_illustration.gif',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              /* BANNER */
              SizedBox(
                height: 10,
              ),
              /* INVITE */
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Undang Temanmu'.toUpperCase(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        fontFamily: 'URW',
                        fontWeight: FontWeight.bold,
                        color: Warna.TextBold,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Ajak temanmu untuk download aplikasi Sipaling Delivery',
                      style: TextStyle(
                        fontFamily: 'URW',
                        fontSize: ScreenUtil().setSp(13),
                        color: Warna.TextNormal,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Bagikan kode referral mu:',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                        fontFamily: 'URW',
                        color: Warna.TextNormal,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            /*    color: Warna.Secondary, */
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '123-456'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'URW',
                              fontWeight: FontWeight.bold,
                              color: Warna.TextBold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.copy,
                            size: 26,
                            color: Warna.Primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: 50.0, // Adjust the height as needed
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Warna.Primary),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Adjust the radius as needed
                              ),
                            ),
                          ),
                          child: Text(
                            'Undang Teman'.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size as needed
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              /* INVITE */
              SizedBox(
                height: 10,
              ),
              /* CARA KERJA */
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BAGAIMANA CARA KERJANYA'.toUpperCase(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(18),
                        fontFamily: 'URW',
                        fontWeight: FontWeight.bold,
                        color: Warna.TextBold,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    /* LANGKAH */
                    for (int index = 0; index < langkah().length; index++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Warna.Primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                (index + 1)
                                    .toString(), // Menggunakan index + 1 sebagai nilai
                                style: TextStyle(
                                  fontFamily: 'URW',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                langkah()[index]['judul'].toString(),
                                style: TextStyle(
                                    fontFamily: 'URW',
                                    fontSize: ScreenUtil().setSp(17),
                                    color: Warna.TextBold,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                langkah()[index]['isi'].toString(),
                                style: TextStyle(
                                  fontFamily: 'URW',
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Warna.TextNormal,
                                ),
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                    /* LANGKAH */
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '*Untuk berpartisipasi dalam program Referral, pelanggan baru (referee) TIDAK memiiki akun yang sudah lebih dari 3 hari, melakukan transaksi di aplikasi, dan menukarkan voucher.',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        fontFamily: 'URW',
                        color: Warna.TextNormal,
                      ),
                    ),
                  ],
                ),
              ),
              /* CARA KERJA */
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class membership_page extends StatefulWidget {
  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<membership_page> {
  /* LIST LANGKAH */
  List<Map<String, dynamic>> pertanyaan() {
    String jsonString = '''
  [
    {
      "judul": "Pertanyaan 1",
      "isi": "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Praesentium neque porro placeat ut quidem impedit nihil eos qui nesciunt alias quo consequuntur hic, blanditiis vitae ullam, assumenda tempore maiores cum!"
    },
    {
      "judul": "Pertanyaan 2",
      "isi": "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Praesentium neque porro placeat ut quidem impedit nihil eos qui nesciunt alias quo consequuntur hic, blanditiis vitae ullam, assumenda tempore maiores cum!"
    },
    {
      "judul": "Pertanyaan 3",
      "isi": "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Praesentium neque porro placeat ut quidem impedit nihil eos qui nesciunt alias quo consequuntur hic, blanditiis vitae ullam, assumenda tempore maiores cum!"
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
          'MEMBERSHIP',
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
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
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
                      'assets/membership_illustration.jpg',
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'POIN KAMU'.toUpperCase(),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              fontFamily: 'URW',
                              fontWeight: FontWeight.bold,
                              color: Warna.TextBold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 20,
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  '2000',
                                  style: TextStyle(
                                      color: Warna.Primary,
                                      fontFamily: 'URW',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'Poin',
                                style: TextStyle(
                                    color: Warna.TextBold,
                                    fontFamily: 'URW',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Riwayat Poin',
                            style: TextStyle(
                              fontFamily: 'URW',
                              fontSize: ScreenUtil().setSp(15),
                              color: Warna.TextBold,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          TextButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor:
                                    MaterialStatePropertyAll(Warna.Primary)),
                            onPressed: () {},
                            child: Text('Lihat Semua'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      /* POIN HISTORY */
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return TextButton(
                                style: ButtonStyle(
                                    overlayColor: MaterialStatePropertyAll(
                                        Warna.Secondary),
                                    foregroundColor: MaterialStatePropertyAll(
                                        Warna.TextBold)),
                                onPressed: () {},
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Warna.BG,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.history),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('100 Poin')
                                        ],
                                      ),
                                      Text('08/09/2023'),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                      /* POIN HISTORY */
                    ],
                  ),
                ),
                /* INVITE */
                SizedBox(
                  height: 10,
                ),
                Divider(),
                /* CARA KERJA */
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PERTANYAAN UMUM'.toUpperCase(),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontFamily: 'URW',
                          fontWeight: FontWeight.bold,
                          color: Warna.TextBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      /* PERTANYAAN */
                      for (int index = 0; index < pertanyaan().length; index++)
                        Container(
                          margin: EdgeInsets.only(top: 3, bottom: 3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Warna.BG),
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            title: Text(
                              pertanyaan()[index]['judul'].toString(),
                              style: TextStyle(
                                  fontFamily: 'URW',
                                  color: Warna.TextBold,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 10,
                            ),
                            children: [
                              ListTile(
                                title: Text(
                                  pertanyaan()[index]['isi'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'URW',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 50,
                                ),
                              )
                            ],
                          ),
                        ),
                      /* PERTANYAAN */
                    ],
                  ),
                ),
                /* CARA KERJA */
              ],
            ),
          ),
        ],
      ),
    );
  }
}

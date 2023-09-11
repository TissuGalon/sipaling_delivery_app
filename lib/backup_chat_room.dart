import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';

class chat_room extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<chat_room> {
  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  'assets/images/me.jpeg'), // Replace with your image asset path
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'MUHAMMAD KHOLIS'.toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF222222),
                    fontFamily: 'URW',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis),
                maxLines: 1,
              ),
            )
          ],
        ),
        actions: [
          TextButton.icon(
              onPressed: () {}, icon: Icon(Icons.phone), label: Text(''))
        ],
        iconTheme: IconThemeData(
          color: Warna.TextBold, // Change the drawer icon color here
        ),
      ),
      /* ISI CHAT */
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Warna.BG,
        ),
        child: ListView(
          children: [
            /* Tanggal */
            Center(
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  '09 Sep',
                  style: TextStyle(
                      color: Warna.TextNormal, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            /* Tanggal */

            /* SAYA */
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              child: Container(
                  margin: EdgeInsets.only(left: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Warna.Primary,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Text(
                        'Lorem ipsum dolor sit amet consectetur, adipisicing elit. Culpa, cupiditate? Quisquam corporis, quaerat totam ut ratione magnam, voluptatum rem nesciunt incidunt necessitatibus impedit ea, molestiae ipsum. Rem voluptates distinctio placeat.',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '12:05 AM',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            color: Warna.Secondary,
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            /* SAYA */

            /* LAWAN */
            Container(
              margin: EdgeInsets.all(5),
              width: double.infinity,
              child: Container(
                  margin: EdgeInsets.only(right: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Text(
                        'Lorem ipsum dolor sit amet consectetur, adipisicing elit. Culpa, cupiditate? Quisquam corporis, quaerat totam ut ratione magnam, voluptatum rem nesciunt incidunt necessitatibus impedit ea, molestiae ipsum. Rem voluptates distinctio placeat.',
                        style: TextStyle(color: Warna.TextNormal),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              '12:05 AM',
                              style: TextStyle(color: Warna.TextBold),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            /* LAWAN */
          ],
        ),
      ),
      /* ISI CHAT */
      /* TOOLBAR CHAT */
      bottomSheet: Container(
        width: double.infinity,
        height: 55,
        color: Colors.white,
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color:
                            Colors.grey[200]!), // Warna border saat tidak aktif
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        color:
                            Warna.TextBold), // Warna border saat aktif (focus)
                  ),
                  filled: true,
                  fillColor: Warna.BG,
                  hintText: 'Ketik pesan...',
                  labelStyle: TextStyle(
                    color: Warna.Primary, // Warna label saat aktif (focus)
                  ),
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.attachment)),
            IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
            Container(
              margin: EdgeInsets.all(3),
              child: CircleAvatar(
                backgroundColor: Warna.Primary,
                radius: 30,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      /* TOOLBAR CHAT */
    );
  }
}

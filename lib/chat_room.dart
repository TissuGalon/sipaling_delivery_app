import 'package:flutter/material.dart';
import 'package:mydelivery/warna.dart';
import 'dart:convert';

class chat_room extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

double calculateWidth(String message, BuildContext context) {
  double maxWidth = maxBubbleWidth(context); // Get the maximum bubble width
  TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: message,
      style: TextStyle(),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
    textAlign: TextAlign.right,
  )..layout(maxWidth: maxWidth);

  // Limit the width to the maximum bubble width
  return textPainter.width <= maxWidth ? textPainter.width + 20 : maxWidth;
}

double maxBubbleWidth(BuildContext context) {
  // Calculate the maximum width based on the screen width
  return MediaQuery.of(context).size.width * 0.7; // 70% of the screen width
}

class _ChatRoomState extends State<chat_room> {
  TextEditingController _messageController = TextEditingController();

  String user_id = "1";

  late String chat_json = ''' [
    {
        "idroom" : 123,
        "iduser1" : "1",
        "iduser2" : "2",
        "chat" : [
            {
                "sender" : "1",
                "date" : "09/09/2023",
                "time" : "13:13",
                "message" : "Lorem ipsum dolor sit amet consectetur adipisicing elit. Unde nihil consequatur eveniet facilis dolores nam aut, vel atque cumque, inventore ullam quod, quam blanditiis? Similique magnam voluptatem veritatis fuga aliquam!",
                "deleted" : false
            },
            {
                "sender" : "2",
                "date" : "09/09/2023",
                "time" : "13:29",
                "message" : "awoakwoakwokaowkowa",
                "deleted" : false
            }
        ]
    }
]''';

  late List<dynamic> chatData;

  void send_message(String message) {
    DateTime now = DateTime.now();
    int hour = now.hour;
    String minute = now.minute.toString().padLeft(2, '0');
    String time = "$hour:$minute";
    // Buat objek pesan baru
    Map<String, dynamic> newMessage = {
      "sender": user_id,
      "date": DateTime.now().toLocal().toString().split(' ')[0],
      "time": time,
      "message": message,
      "deleted": false
    };

    // Dapatkan indeks percakapan yang sedang aktif
    int activeChatIndex = 0; // Sesuaikan sesuai dengan kebutuhan

    // Tambahkan pesan baru ke dalam daftar percakapan aktif
    setState(() {
      chatData[activeChatIndex]["chat"].add(newMessage);
    });
    // Bersihkan input teks setelah pesan terkirim
    _messageController.clear();
  }

  @override
  void initState() {
    super.initState();
    // Parse string JSON menjadi objek Dart
    chatData = json.decode(chat_json);
  }

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
        margin: EdgeInsets.only(bottom: 70),
        color: Warna.BG,
        child: ListView.builder(
          itemCount: chatData[0]["chat"].length,
          itemBuilder: (context, index) {
            /* SAYA */
            if (chatData[0]["chat"][index]["sender"] == user_id) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: calculateWidth(
                        chatData[0]["chat"][index]["message"] +
                            chatData[0]["chat"][index]["time"].toString(),
                        context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatData[0]["chat"][index]["message"].toString(),
                          style: TextStyle(color: Warna.TextBold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Text(
                              chatData[0]["chat"][index]["time"].toString(),
                              style: TextStyle(color: Warna.TextBold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              /* SAYA */
            } else {
              /* LAWAN */
              if (chatData[0]["chat"][index]["sender"] != user_id)
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: calculateWidth(
                          chatData[0]["chat"][index]["message"], context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chatData[0]["chat"][index]["message"].toString(),
                            style: TextStyle(color: Warna.TextBold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(), // Spacer added to push the time to the right
                              Text(
                                chatData[0]["chat"][index]["time"].toString(),
                                style: TextStyle(color: Warna.TextBold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              /* LAWAN */
            }
          },
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
              controller: _messageController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15), // Atur padding sesuai keinginan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                      color:
                          Colors.grey[200]!), // Warna border saat tidak aktif
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                      color: Warna.TextBold), // Warna border saat aktif (focus)
                ),
                filled: true,
                fillColor: Warna.BG,
                hintText: 'Ketik pesan...',
                labelStyle: TextStyle(
                  color: Warna.Primary, // Warna label saat aktif (focus)
                ),
              ),
            )),
            IconButton(onPressed: () {}, icon: Icon(Icons.attachment)),
            IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
            Container(
              margin: EdgeInsets.all(3),
              child: CircleAvatar(
                backgroundColor: Warna.Primary,
                radius: 30,
                child: IconButton(
                  onPressed: () {
                    send_message(_messageController.text);
                  },
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

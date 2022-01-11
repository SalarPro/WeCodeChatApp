import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wecode2/src/custom_view/custome_view.dart';
import 'package:wecode2/src/data_model/message_model.dart';
import 'package:intl/intl.dart';

import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();

  String username = "ENTER_YOUR_NAME";
  //to scroll the view when reciving new message
  final ScrollController? _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy("createdAt")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return loadingProgressIndicator();
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return loadingProgressIndicator();
                  } else {
                    List<DocumentSnapshot> _docs = snapshot.data!.docs;

                    List<Message> _users = _docs
                        .map((e) =>
                            Message.fromMap(e.data() as Map<String, dynamic>))
                        .toList();
                    _scrollDown();
                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          bool isMe = (username.toLowerCase() ==
                              _users[index].username.toString().toLowerCase());
                          if (isMe) {
                            return myBuble(_users[index]);
                          } else {
                            return partnerBuble(_users[index]);
                          }
                        });
                  }
                },
              )),
            ),
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.lightBlue[100],
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: CustomView.ganeralInputDecoration(
                          labelText: "Message..."),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'The message is required';
                        } else
                          return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_messageController.value.text != "") {
                        Message mes = Message(
                            message: _messageController.value.text.trim(),
                            username: username,
                            createdAt: Timestamp.fromDate(DateTime.now()));
                        _messageController.text = "";
                        await FirebaseFirestore.instance
                            .collection('messages')
                            .add(mes.toMap())
                            .then((value) {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column loadingProgressIndicator() {
    return Column(
      children: [
        Expanded(child: Container()),
        CircularProgressIndicator(
          color: Colors.yellow,
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Row partnerBuble(Message message) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //username Text
              Container(child: Text(message.username ?? 'Anonymous')),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[500],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Text(message.message ?? 'no message'),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(message.createdAt!.toDate()),
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: SizedBox(
          width: 50,
        )),
      ],
    );
  }

  Row myBuble(Message message) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          width: 50,
        )),
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.username ?? 'Anonymous'),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Text(message.message ?? 'no message'),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(message.createdAt!.toDate()),
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // This is what you're looking for!
  Future _scrollDown() async {
    debugPrint("_scrollDown");
    if (_scrollController != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        _scrollController!.animateTo(
          false
              ? _scrollController!.position.minScrollExtent
              : _scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
}

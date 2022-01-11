import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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

  String username = "null_user";
  TextEditingController _textFieldController = TextEditingController();
  //to scroll the view when reciving new message
  final ScrollController? _scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () => showAlert(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroudImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shadowColor: Colors.blue,
            title: Row(
              children: [
                Container(
                    width: 40,
                    height: 40,
                    child: Image(image: AssetImage('src/image/profile.png'))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  username == "null_user" ? "" : username.toTitleCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )),
                Container(
                    width: 40,
                    height: 40,
                    child: Image(image: AssetImage('src/image/chat.png'))),
              ],
            ),
            backgroundColor: Colors.transparent,
          ),
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
                            .map((e) => Message.fromMap(
                                e.data() as Map<String, dynamic>))
                            .toList();
                        _scrollDown();
                        return ListView.builder(
                            controller: _scrollController,
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              bool isMe = (username.toLowerCase() ==
                                  _users[index]
                                      .username
                                      .toString()
                                      .toLowerCase());
                              if (!isMe || username == "ENTER_YOUR_NAME") {
                                return partnerBuble(_users[index]);
                              } else {
                                return myBuble(_users[index]);
                              }
                            });
                      }
                    },
                  )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          controller: _messageController,
                          // decoration: CustomView.ganeralInputDecoration(
                          //     labelText: "Message..."),
                          decoration: InputDecoration(
                            hintText: "Message...",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'The message is required';
                            } else
                              return null;
                          },
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        child: TextButton(
                            onPressed: () async {
                              if (_messageController.value.text != "") {
                                String _uid = Uuid().v1();
                                Message mes = Message(
                                    message:
                                        _messageController.value.text.trim(),
                                    username: username,
                                    uid: _uid,
                                    createdAt:
                                        Timestamp.fromDate(DateTime.now()));
                                _messageController.text = "";
                                await FirebaseFirestore.instance
                                    .collection('messages')
                                    .doc(_uid)
                                    .set(mes.toMap())
                                    .then((value) {});
                              }
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset('src/image/send.png')
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 4,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Column loadingProgressIndicator() {
    return Column(
      children: [
        Expanded(child: Container()),
        CircularProgressIndicator(
          color: Colors.blue[500],
        ),
        Expanded(child: Container()),
      ],
    );
  }

//partner Buble
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
              Container(
                  child: Text(
                (message.username ?? 'Anonymous').toTitleCase(),
                style: TextStyle(color: Colors.white, fontSize: 13),
              )),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(0),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message ?? 'no message',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            DateFormat('hh:kk')
                                .format(message.createdAt!.toDate()),
                            style: TextStyle(fontSize: 8, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () async {
                  //     await FirebaseFirestore.instance
                  //         .collection("messages")
                  //         .doc(message.uid!)
                  //         .delete();
                  //   },
                  // ),
                ],
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

//User Buble
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
              // Text(message.username ?? 'Anonymous'),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("messages")
                          .doc(message.uid!)
                          .delete();
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0),
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.message ?? 'no message',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            DateFormat('hh:kk')
                                .format(message.createdAt!.toDate()),
                            style: TextStyle(fontSize: 8, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

  void showAlert(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        controller: _textFieldController,
                        decoration:
                            InputDecoration(hintText: "Enter your name"),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              username = _textFieldController.text;

                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text("Start Chating"))
                  ],
                ),
              ),
            ));
  }

  Widget backgroudImage() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('src/image/bg1.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

import 'package:cloud_firestore/cloud_firestore.dart';
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
    return Scaffold(
        appBar: AppBar(title: Text(username)),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    color: Colors.black12,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('messages')
                          .orderBy("createdAt")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('error');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('empty');
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
                                if (isMe) {
                                  return myBuble(isMe, _users, index);
                                } else {
                                  return partnerBuble(_users, index, isMe);
                                }
                              });
                        }
                      },
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration:
                          CustomView.ganeralInputDecoration(labelText: "Aa.."),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'the phone number is required';
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

                        await FirebaseFirestore.instance
                            .collection('messages')
                            .add(mes.toMap());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Row partnerBuble(List<Message> _users, int index, bool isMe) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //username Text
              Container(child: Text(_users[index].username ?? 'Anonymous')),
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
                child: Text(_users[index].message ?? 'no message'),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(_users[index].createdAt!.toDate()),
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: SizedBox(
          width: isMe ? 100 : 0,
        )),
      ],
    );
  }

  Row myBuble(bool isMe, List<Message> _users, int index) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          width: isMe ? 100 : 0,
        )),
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_users[index].username ?? 'Anonymous'),
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
                child: Text(_users[index].message ?? 'no message'),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                child: Text(
                  DateFormat('yyyy-MM-dd hh:mma')
                      .format(_users[index].createdAt!.toDate()),
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

  void showAlert(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
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
                      decoration: InputDecoration(hintText: "Enter your name"),
                    ),
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
                      child: Text("insert"))
                ],
              ),
            ));
  }
}

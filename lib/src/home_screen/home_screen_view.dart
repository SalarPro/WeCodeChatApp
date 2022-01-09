import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wecode2/src/custom_view/custome_view.dart';
import 'package:wecode2/src/data_model/message_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('messages').get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('error');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('empty');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        List<DocumentSnapshot> _docs = snapshot.data!.docs;

                        List<Message> _users = _docs
                            .map((e) => Message.fromMap(
                                e.data() as Map<String, dynamic>))
                            .toList();

                        return ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              return Text(
                                  _users[index].message ?? 'no message');
                            });
                      }
                      return LinearProgressIndicator();
                    },
                  ),
                  TextFormField(
                    controller: _messageController,
                    decoration: CustomView.ganeralInputDecoration(
                        labelText: "labelText"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'the phone number is required';
                      } else
                        return null;
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        if (_messageController.value.text != "") {
                          Message mes = Message(
                              message: _messageController.value.text.trim());

                          FirebaseFirestore.instance
                              .collection('users')
                              .add(mes.toMap());
                        }
                      });
                    },
                    icon: Icon(
                      Icons.login,
                    ),
                    label: Text(""),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

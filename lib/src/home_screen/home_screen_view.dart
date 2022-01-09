import 'package:flutter/material.dart';
import 'package:wecode2/src/custom_view/custome_view.dart';

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
                  TextFormField(
                    controller: _messageController,
                    decoration:
                        CustomView.ganeralInputDecoration(labelText: "labelText"),
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

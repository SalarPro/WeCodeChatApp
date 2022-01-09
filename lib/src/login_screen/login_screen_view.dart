import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:wecode2/src/trainer_screen/trainer_scree_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = "";
  String? passwrod;

  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      debugPrint(user.toString());
    });

    return Scaffold(
      body: Scaffold(
          appBar: AppBar(
            title: const Text("Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    'Welcome $name',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                ),
                Form(
                    child: Column(
                  children: [
                    FutureBuilder<String>(
                        future: waitThreeSeconds(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Text(snapshot.data.toString());
                          }
                        }),

                    //User name
                    TextFormField(
                      controller: userNameController,
                      decoration: ganeralInputDecoration(
                          labelText: "Email", hintText: "example@example.com"),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(
                      height: 14,
                    ),

                    //Password
                    TextFormField(
                      decoration: ganeralInputDecoration(labelText: "Password"),
                      obscureText: true,
                      controller: passwordController,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              passwrod = passwordController.value.text.trim();
                              name = userNameController.value.text
                                  .trim()
                                  .toLowerCase();
                            });

                            await auth
                                .createUserWithEmailAndPassword(
                                    email: name, password: passwrod!)
                                .then(
                                    (value) => value.user?.uid ?? "no uid :P");
                          },
                          icon: Icon(Icons.login),
                          label: Text('Login')),
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }

  InputDecoration ganeralInputDecoration(
      {required String labelText, String? hintText}) {
    return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));
  }

  Future<String> waitThreeSeconds() async {
    await Future.delayed(Duration(seconds: 3));
    return 'Hello';
  }
}

import 'package:flutter/material.dart';
import 'package:wecode2/src/custom_view/custome_view.dart';
import 'package:wecode2/src/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String? passwrod;

  AuthService _auth = AuthService();

  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();

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
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: const Text(
                    'Welcome',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                ),
                Form(
                    child: Column(
                  children: [
                    //User name
                    TextFormField(
                      controller: _userNameController,
                      decoration: CustomView.ganeralInputDecoration(
                          labelText: "Email", hintText: "example@example.com"),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    //Password
                    TextFormField(
                      decoration: CustomView.ganeralInputDecoration(
                          labelText: "Password"),
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              passwrod = _passwordController.value.text.trim();
                              email = _userNameController.value.text
                                  .trim()
                                  .toLowerCase();
                            });

                            if (passwrod != null) {
                              //singing with FireStore
                              _auth.loginWihtEmailAndPassword(email, passwrod!);
                            }
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Login')),
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }
}
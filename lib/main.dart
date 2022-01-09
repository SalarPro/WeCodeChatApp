import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wecode2/src/home_screen/home_screen_view.dart';
import 'package:wecode2/src/login_screen/login_screen_view.dart';
import 'package:wecode2/src/provider/auth_provider.dart';
import 'package:wecode2/src/register_screen/registr_screen.dart';
import 'package:wecode2/src/student_screen/StudentScreenView.dart';

void main() {
  runApp(MultiProvider(
    child: MainApp(),
    providers: [ChangeNotifierProvider(create: (context) => AuthPorvider())],
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Firebase
    Firebase.initializeApp();

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/student': (context) => StudentScreenView(),
        '/register': (context) => RegistrScreen(),
      },
    );
  }
}

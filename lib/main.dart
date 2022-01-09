import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wecode2/src/home_screen/home_screen_view.dart';

void main() {
  runApp( MainApp());
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
      },
    );
  }
}

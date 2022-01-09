import 'package:flutter/material.dart';

class StudentScreenView extends StatefulWidget {
  StudentScreenView({Key? key}) : super(key: key);

  @override
  _StudentScreenViewState createState() => _StudentScreenViewState();
}

class _StudentScreenViewState extends State<StudentScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Student Screen'),
    );
  }
}

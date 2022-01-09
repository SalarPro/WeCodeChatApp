import 'package:flutter/material.dart';

class CustomView{

 static InputDecoration ganeralInputDecoration(
      {required String labelText, String? hintText}) {
    return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)));
  }
}

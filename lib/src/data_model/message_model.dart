import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  

  Message(
      {
      this.message,
      });

  // from map which reads the data from the database

  factory Message.fromMap(Map<String, dynamic> json) => Message(
      
      message: json["message"],
      );

  // toMap()
  Map<String, dynamic> toMap() => {
        
        "message": message,
      };
}

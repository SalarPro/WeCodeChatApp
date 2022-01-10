import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  Timestamp? createdAt;
  String? username;

  Message({this.message, this.createdAt, this.username});

  // from map which reads the data from the database

  factory Message.fromMap(Map<String, dynamic> json) => Message(
        message: json["message"],
        createdAt: json["createdAt"],
        username: json["username"],
      );

  // toMap()
  Map<String, dynamic> toMap() => {
        "message": message,
        "createdAt": createdAt,
        "username": username,
      };
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? name;
  String? email;
  String? github;
  String? stackOverflow;
  int? points;
  int? thumbsUps;
  String? imgUrl;
  String? phoneNumber;
  bool? isTeacher;
  bool? isAdmin;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? bootCampId;
  String? bootCampName;

  User({
    this.name,
    this.email,
    this.github,
    this.stackOverflow,
    this.points,
    this.thumbsUps,
    this.imgUrl,
    this.phoneNumber,
    this.isTeacher,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
    this.bootCampId,
    this.bootCampName,
  });





  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'github': github,
      'stackOverflow': stackOverflow,
      'points': points,
      'thumbsUps': thumbsUps,
      'imgUrl': imgUrl,
      'phoneNumber': phoneNumber,
      'isTeacher': isTeacher,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bootCampId': bootCampId,
      'bootCampName': bootCampName,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      github: map['github'],
      stackOverflow: map['stackOverflow'],
      points: map['points']?.toInt(),
      thumbsUps: map['thumbsUps']?.toInt(),
      imgUrl: map['imgUrl'],
      phoneNumber: map['phoneNumber'],
      isTeacher: map['isTeacher'],
      isAdmin: map['isAdmin'],
      createdAt: map['createdAt'] ,
      updatedAt: map['updatedAt'] ,
      bootCampId: map['bootCampId'],
      bootCampName: map['bootCampName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, email: $email, github: $github, stackOverflow: $stackOverflow, points: $points, thumbsUps: $thumbsUps, imgUrl: $imgUrl, phoneNumber: $phoneNumber, isTeacher: $isTeacher, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt, bootCampId: $bootCampId, bootCampName: $bootCampName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.name == name &&
      other.email == email &&
      other.github == github &&
      other.stackOverflow == stackOverflow &&
      other.points == points &&
      other.thumbsUps == thumbsUps &&
      other.imgUrl == imgUrl &&
      other.phoneNumber == phoneNumber &&
      other.isTeacher == isTeacher &&
      other.isAdmin == isAdmin &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.bootCampId == bootCampId &&
      other.bootCampName == bootCampName;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      github.hashCode ^
      stackOverflow.hashCode ^
      points.hashCode ^
      thumbsUps.hashCode ^
      imgUrl.hashCode ^
      phoneNumber.hashCode ^
      isTeacher.hashCode ^
      isAdmin.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      bootCampId.hashCode ^
      bootCampName.hashCode;
  }
}

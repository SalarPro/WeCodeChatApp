import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wecode2/src/temp/student_muck_data.dart';
import 'package:http/http.dart' as http;

class TrainerView extends StatelessWidget {
  const TrainerView({Key? key, this.username, this.passeord}) : super(key: key);

  final String? username;
  final String? passeord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: /*salarStyleList(),*/
            Container(
          child: FutureBuilder(
              future: getStudents(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  //while loading data
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  //if there is Error
                  return CircularProgressIndicator(
                    color: Colors.red[100],
                  );
                } else {
                  //if there is data
                  return salarStyleList((snapshot.data as List<String>));
                  //Text(snapshot.data.toString());
                }
              }),
        ));
  }

  Center salarStyleList(List<String> names) {
    return Center(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return theStudentCard(names[index]);
        },
      ),
    );
  }

  Container theStudentCard(String stdName) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Text(stdName),
    );
  }

//get json data from link
  Future<List<String>> getStudents() async {
    String sourceLink = "https://jsonplaceholder.typicode.com/users";
    http.Response response = await http.get(Uri.parse(sourceLink));

    String responseString = "";

    List decodJson = jsonDecode(response.body);

    return decodJson.map((e) => e["name"].toString()).toList();
  }
}

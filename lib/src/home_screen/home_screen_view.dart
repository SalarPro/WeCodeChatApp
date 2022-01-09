import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
            Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Divider(
                  color: Colors.grey[900],
                  height: 25,
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Login')),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text('Register')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

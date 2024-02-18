import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to SeeFood',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          )),
        Card(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Username'),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextField(
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Password'),
                  ),
                ),
                SizedBox(height: 20),
              ]),
          )
        ),
        ElevatedButton(
          onPressed: () {
            appState.login();
          },
          child: Column(
            children: [Text('Login'), Icon(Icons.arrow_forward)],
          ),
        ),
      ],
    ));
  }
}

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
        Card(
          child: Column(children: [
            Text('Login Page'),
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
            ElevatedButton(
              onPressed: () {
                appState.login();
              },
              child: Column(
                children: [Text('Login'), Icon(Icons.arrow_forward)],
              ),
            ),
          ]),
        ),
      ],
    ));
  }
}

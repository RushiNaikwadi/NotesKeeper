import 'package:flutter/material.dart';
import 'package:todo/Auth/AuthForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Authentication',
      //     style: TextStyle(
      //       color: Colors.yellow,
      //     ),
      //
      //   ),
      //   centerTitle: true,
      // ),
      body: AuthForm(),
    );
  }
}

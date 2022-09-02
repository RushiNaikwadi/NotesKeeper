import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Auth/AuthScreen.dart';
import 'package:todo/screens/AddTask.dart';
import 'package:todo/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => Home(),
        '/addtask': (context) => AddTask(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot) {
          if (usersnapshot.hasData) {
            return const Home();
          } else {
            return const AuthScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.indigo),
    );
  }
}







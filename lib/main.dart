import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toukri/app/screens/login.dart';
import 'package:toukri/app/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      Firebase.initializeApp();
    return MaterialApp(
      title: 'Toukri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.lightGreenAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}

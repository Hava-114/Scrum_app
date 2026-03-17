import 'package:flutter/material.dart';
import 'package:scrum_app/view/home.dart';
import 'package:scrum_app/view/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(), 
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spaceship_service/constants.dart';

import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spaceship Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        fontFamily: 'Poppins',
      ),
      home: const HomePage(title: 'LICITEAZĂ'),
    );
  }
}

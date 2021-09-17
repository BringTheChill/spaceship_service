import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaceship_service/constants.dart';
import 'package:spaceship_service/models/appointment_data.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppointmentData(),
      child: MaterialApp(
        title: 'Spaceship Service',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          fontFamily: 'Poppins',
        ),
        home: const HomePage(title: 'LICITEAZĂ'),
      ),
    );
  }
}

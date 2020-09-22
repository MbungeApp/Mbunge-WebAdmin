import 'package:flutter/material.dart';
import 'package:mbungedashboard/screens/login.dart';
import 'package:mbungedashboard/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: AppColors.whiteColor,
      ),
      home: LoginPage(),
    );
  }
}

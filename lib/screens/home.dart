import 'package:flutter/material.dart';

import 'dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Color(0xFFC37500),
              child: Column(),
            ),
          ),
          Flexible(
            flex: 9,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: PageView(
                children: [
                  DashboarHome()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mbungeweb/screens/account/login_page.dart';
import 'package:mbungeweb/screens/home/home_page.dart';

class AppRouter {
  static const String loginRoute = "/login";
  static const String homeRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return _route(
          LoginPage(),
        );
        break;
      case homeRoute:
        return _route(
          HomePage(),
        );
        break;
      default:
        return _route(
          Scaffold(
            appBar: AppBar(
              title: Text('Web'),
            ),
            body: Center(
              child: Text('Unknown page'),
            ),
          ),
        );
        break;
    }
  }

  static _route(Widget page) {
    return CupertinoPageRoute(
      builder: (context) {
        return page;
      },
    );
  }
}

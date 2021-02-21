import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mbungeweb/models/home_navigation.dart';
import 'package:mbungeweb/screens/account/login_page.dart';
import 'package:mbungeweb/screens/home/home_page.dart';

class AppRouter {
  static const String loginRoute = "/login";
  static const String homeRoute = "/home";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case loginRoute:
        return _route(
          LoginPage(),
        );
        break;
      case homeRoute:
        HomeNavigationModel arguments = args;
        return _route(
          HomePage(
            token: arguments.token,
            userModel: arguments.userModel,
          ),
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

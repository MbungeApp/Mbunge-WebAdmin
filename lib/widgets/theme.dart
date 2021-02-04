import 'package:flutter/material.dart';

class AppTheme {
  bool isDark;
  Color bg1; //
  Color surface; //
  Color bg2;
  Color accent1;
  Color accent1Dark;
  Color accent1Darker;
  Color accent2;
  Color accent3;
  Color grey;
  Color greyStrong;
  Color greyWeak;
  Color error;
  Color focus;

  Color txt;
  Color accentTxt;

  AppTheme({@required this.isDark});

  AppTheme get appTheme => this.isDark ? isDarkTheme() : isLightTheme();

  AppTheme isLightTheme() {
    return AppTheme(isDark: false)
      ..bg1 = Color(0xfff1f7f0)
      ..bg2 = Color(0xffc1dcbc)
      ..surface = Colors.white
      ..accent1 = Color(0xff00a086)
      ..accent1Dark = Color(0xff00856f)
      ..accent1Darker = Color(0xff006b5a)
      ..accent2 = Color(0xfff09433)
      ..accent3 = Color(0xff5bc91a)
      ..greyWeak = Color(0xff909f9c)
      ..grey = Color(0xff515d5a)
      ..greyStrong = Color(0xff151918)
      ..error = Colors.red.shade900
      ..focus = Color(0xFF0ee2b1)
      ..txt = Colors.black
      ..accentTxt = Colors.black;
  }

  AppTheme isDarkTheme() {
    return AppTheme(isDark: true)
      ..bg1 = Color(0xff00120f) //Color(0xff121212)
      ..bg2 = Color(0xff2c2c2c)
      ..surface = Color(0xff252525)
      ..accent1 = Color(0xff00a086)
      ..accent1Dark = Color(0xff00caa5)
      ..accent1Darker = Color(0xff00caa5)
      ..accent2 = Color(0xfff19e46)
      ..accent3 = Color(0xff5BC91A)
      ..greyWeak = Color(0xffa8b3b0)
      ..grey = Color(0xffced4d3)
      ..greyStrong = Color(0xffffffff)
      ..error = Color(0xffe55642)
      ..focus = Color(0xff0ee2b1)
      ..txt = Colors.white
      ..accentTxt = Colors.white;
  }
}

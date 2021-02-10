import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Types {
  info,
  error,
  debug,
  success,
}

class CustomToast {
  static showToast(
      {@required String message,
      @required Types type,
      @required ToastGravity toastGravity}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: _setupBgColor(type),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Color _setupBgColor(Types type) {
    Color color;
    switch (type) {
      case Types.info:
        color = Colors.blue;
        break;
      case Types.debug:
        color = Colors.orange;
        break;
      case Types.success:
        color = Colors.green;
        break;
      case Types.error:
        color = Colors.red;
        break;

      default:
        return Colors.teal;
    }
    return color;
  }
}

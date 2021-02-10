import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Widget child;

  const CustomErrorWidget({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset("assets/images/error.gif"),
        ),
        SizedBox(height: 20),
        child,
      ],
    );
  }
}

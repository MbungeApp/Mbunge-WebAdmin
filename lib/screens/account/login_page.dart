import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/utils/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 10.0,
            child: SizedBox(
              width: size.width * 0.45,
              child: Row(
                children: [
                  Flexible(
                    child: Image.network(
                      "https://picsum.photos/300/300",
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Welcome Back!",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter Email adddress..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Input cannot be null";
                              }
                              return value;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Input cannot be null";
                              }
                              return value;
                            },
                          ),
                          SizedBox(height: 25),
                          CupertinoButton.filled(
                            child: Text("login"),
                            borderRadius: BorderRadius.circular(30),
                            onPressed: () {
                              Navigator.pushNamed(context, AppRouter.homeRoute);
                            },
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            onPressed: () {},
                            child: Text("Forgot password?"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

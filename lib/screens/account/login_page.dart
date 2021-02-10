import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/models/home_navigation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/utils/routes.dart';
import 'package:mbungeweb/widgets/toast.dart';

class LoginPage extends StatefulWidget {
  final LoginCubit loginCubit;

  const LoginPage({Key key, @required this.loginCubit}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController;
  TextEditingController passwordController;
  LoginCubit get _loginCubit => widget.loginCubit;
  bool isObscured = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      cubit: _loginCubit,
      listener: (context, state) {
        if (state is UserLoggedOut) {
          // navigate to login page
          Navigator.popAndPushNamed(
            context,
            AppRouter.loginRoute,
            arguments: [_loginCubit],
          );
        }
        if (state is UserLoggedIn) {
          String token = state.token;
          UserModel userModel = state.userModel;
          // navigate home
          Navigator.popAndPushNamed(
            context,
            AppRouter.homeRoute,
            arguments: HomeNavigationModel(
              token,
              userModel,
              _loginCubit,
            ),
          );
        }
        if (state is LoginError) {
          CustomToast.showToast(
            message: "${state.message}",
            type: Types.error,
            toastGravity: ToastGravity.BOTTOM_RIGHT,
          );
        }
      },
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Welcome Back!",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                controller: emailController,
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
                                  if (!isValidEmail(value)) {
                                    return "Email address invalid";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  emailController.text = value;
                                },
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                obscureText: isObscured,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  hintText: "password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(),
                                  ),
                                  suffix: GestureDetector(
                                    child: Icon(
                                      isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isObscured = !isObscured;
                                      });
                                    },
                                  ),
                                ),
                                onSaved: (value) {
                                  passwordController.text = value;
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Input cannot be null";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25),
                              CupertinoButton.filled(
                                child: Text("login"),
                                borderRadius: BorderRadius.circular(30),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                  }
                                  print(
                                    "Email: ${emailController.text}",
                                  );
                                  print(
                                    "Password: ${passwordController.text}",
                                  );
                                  _loginCubit.loginUser(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text("Forgot password?"),
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }
}

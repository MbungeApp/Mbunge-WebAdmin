import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/models/home_navigation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/utils/routes.dart';
import 'package:mbungeweb/widgets/toast.dart';

class DecisionPage extends StatelessWidget {
  final LoginCubit loginCubit;

  const DecisionPage({Key key, @required this.loginCubit}) : super(key: key);

  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: loginCubit,
      builder: (context, state) {
        AppLogger.logWTF(state.toString());
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (state is UserLoggedOut) {
            // navigate to login page

            Navigator.popAndPushNamed(
              context,
              AppRouter.loginRoute,
              arguments: [loginCubit],
            );
          }
          if (state is UserLoggedIn) {
            String token = state.token;
            UserModel userModel = state.userModel;
            AppLogger.logWTF(userModel.toJson().toString());
            // navigate home
            CustomToast.showToast(
              message: "Login",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
            Navigator.popAndPushNamed(
              context,
              AppRouter.homeRoute,
              arguments: HomeNavigationModel(
                token,
                userModel,
                loginCubit,
              ),
            );
          }
        });
        if (state is LoginError) {
          CustomToast.showToast(
            message: "${state.message}",
            type: Types.error,
            toastGravity: ToastGravity.BOTTOM_RIGHT,
          );
        }
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/authentication/authenticiation_cubit.dart';
import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/models/home_navigation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/repository/shared_preference_repo.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/utils/routes.dart';
import 'package:mbungeweb/widgets/toast.dart';

class DecisionPage extends StatefulWidget {
  const DecisionPage({
    Key key,
  }) : super(key: key);

  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  AuthenticiationCubit authenticiationCubit;

  @override
  void initState() {
    authenticiationCubit = AuthenticiationCubit(
      AdminRepo(),
      SharedPreferenceRepo(),
    );
    authenticiationCubit.isUserLoggedIn();
    super.initState();
  }

  @override
  void dispose() {
    authenticiationCubit?.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: authenticiationCubit,
      builder: (context, state) {
        AppLogger.logWTF(state.toString());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is AuthenticiationLoggedOut) {
            // navigate to login page

            print("++++++++++++ go login ++++++++++++");
            Navigator.popAndPushNamed(
              context,
              AppRouter.loginRoute,
            );
          }
          if (state is AuthenticiationLoggedIn) {
            print("++++++++++++ go home ++++++++++++");
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
              ),
            );
          }
        });
        if (state is LoginError) {
          CustomToast.showToast(
            message: "${state.message} refresh the page",
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

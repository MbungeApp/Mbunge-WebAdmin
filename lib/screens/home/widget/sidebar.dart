import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/models/home_navigation.dart';
import 'package:mbungeweb/models/navigation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/utils/routes.dart';
import 'package:mbungeweb/widgets/toast.dart';

import 'sidebar_item.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key key,
    @required this.currentIndex,
    this.onTap,
    @required this.userModel,
    @required this.loginCubit,
  }) : super(key: key);

  final int currentIndex;
  final Function(int value) onTap;
  final UserModel userModel;
  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: loginCubit,
      builder: (context, state) {
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
            // navigate home
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
          if (state is LoginError) {
            CustomToast.showToast(
              message: "${state.message}",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
          }
        });
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(28, 50, 0, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(userModel.admin.emailAddress ?? "Admin"),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sidebarData.map((e) {
                    return SidebarItem(
                      isActive:
                          sidebarData.indexOf(e) == currentIndex ? true : false,
                      title: e.title,
                      icon: e.icon,
                      onTap: () {
                        _navigate(sidebarData.indexOf(e));
                      },
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              SidebarItem(
                isActive: false,
                title: "Logout",
                icon: Icons.exit_to_app,
                onTap: () {
                  loginCubit.logOutUser();
                },
              ),
              SizedBox(height: 30)
            ],
          ),
        );
      },
    );
  }

  void _navigate(int value) {
    if (value == null) return;
    onTap(value);
  }
}

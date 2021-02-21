import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/cubit/authentication/authenticiation_cubit.dart';
import 'package:mbungeweb/models/navigation.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/repository/shared_preference_repo.dart';
import 'package:mbungeweb/widgets/restart_widget.dart';

import 'sidebar_item.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    Key key,
    @required this.currentIndex,
    @required this.userModel,
    this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final Function(int value) onTap;
  final UserModel userModel;

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  AuthenticiationCubit authenticiationCubit;

  @override
  void initState() {
    authenticiationCubit = AuthenticiationCubit(
      AdminRepo(),
      SharedPreferenceRepo(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authenticiationCubit,
      child: BlocListener(
        cubit: authenticiationCubit,
        listener: (context, state) {
          if (state is AuthenticiationLoggedOut) {
            RestartWidget.restartApp(context);
          }
        },
        child: Container(
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
                    Text("Hello, ${widget.userModel.admin.name}"),
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
                      isActive: sidebarData.indexOf(e) == widget.currentIndex
                          ? true
                          : false,
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
                  authenticiationCubit.logOutUser();
                },
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
    //   },
    // );
  }

  void _navigate(int value) {
    if (value == null) return;
    widget.onTap(value);
  }
}

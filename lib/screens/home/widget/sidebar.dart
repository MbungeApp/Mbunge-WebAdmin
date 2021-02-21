import 'package:flutter/material.dart';
import 'package:mbungeweb/models/navigation.dart';
import 'package:mbungeweb/models/user_model.dart';

import 'sidebar_item.dart';

class Sidebar extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                Text("Hello, ${userModel.admin.name}"),
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
              // loginCubit.logOutUser();
            },
          ),
          SizedBox(height: 30)
        ],
      ),
    );
    //   },
    // );
  }

  void _navigate(int value) {
    if (value == null) return;
    onTap(value);
  }
}

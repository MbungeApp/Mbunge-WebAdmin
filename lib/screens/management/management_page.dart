import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/admin/admin_cubit.dart';
import 'package:mbungeweb/models/admin_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/screens/management/widgets/add_admin_page.dart';
import 'package:mbungeweb/widgets/activity_overlay.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  AdminCubit _adminCubit;
  ActivityOverlay _activityOverlay;
  ValueNotifier<bool> isActivityOpened = ValueNotifier(false);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _adminCubit = AdminCubit(
      adminRepo: AdminRepo(),
    );
    _adminCubit.fetchAdmins();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _activityOverlay = ActivityOverlay(
      context,
      AddAdminPage(
        adminCubit: _adminCubit,
        controller: _animationController,
        close: () {
          isActivityOpened.value = false;
          _animationController.reverse().whenComplete(() {
            _activityOverlay?.remove();
          });
        },
      ),
    );
    isActivityOpened.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _adminCubit?.close();
    _animationController?.dispose();
    isActivityOpened?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          if (_activityOverlay.isVisible()) {
            _animationController.reverse().whenComplete(() {
              _activityOverlay?.remove();
              isActivityOpened.value = false;
            });
          }
        },
        child: BlocProvider(
          create: (context) => _adminCubit,
          child: ClipRRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 28),
                    buildTopPart(theme),
                    SizedBox(height: 28),
                    BlocConsumer(
                      cubit: _adminCubit,
                      listener: (context, state) {
                        if (state is AdminSuccess) {
                          Fluttertoast.showToast(
                            msg: state.actionState.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AdminInitial) {
                          return LoadingWidget();
                        }
                        if (state is AdminError) {
                          return CustomErrorWidget(
                            child: Text(state.message),
                          );
                        }
                        if (state is AdminSuccess) {
                          final admins = state.admins;
                          if (admins.isEmpty) {
                            return CustomErrorWidget(
                              child: Text("MPs are empty, please add some"),
                            );
                          }
                          return Flexible(
                            child: buildDataTable(admins),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
                isActivityOpened.value
                    ? Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(
                            sigmaX: isActivityOpened.value ? 5 : 0,
                            sigmaY: isActivityOpened.value ? 5 : 0,
                          ),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDataTable(List<AdminModel> admins) {
    List<String> _columns = [
      "Index",
      "Name",
      "National ID",
      "Email Address",
      "Role",
      "Created At",
      "Actions",
    ];
    return ScrollbarListStack(
      controller: scrollController,
      barSize: 10,
      axis: Axis.vertical,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: _columns.map((col) {
                    return DataColumn(
                      label: Text(
                        col,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      numeric: false,
                      onSort: (a, b) {},
                    );
                  }).toList(),
                  rows: [
                    for (int i = 0; i < admins.length; i++)
                      DataRow(
                        selected: i % 2 == 0 ? true : false,
                        cells: [
                          DataCell(Text("$i")),
                          DataCell(Text("${admins[i].name}")),
                          DataCell(Text("${admins[i].nationalId}")),
                          DataCell(Text("${admins[i].emailAddress}")),
                          DataCell(Text("${admins[i].role}")),
                          DataCell(Text(
                            "${DateFormat.yMEd().format(admins[i].createdAt ?? DateTime.now())}",
                          )),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                                SizedBox(width: 5),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _adminCubit.deleteAdmin(admins[i].id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelectChanged: (value) {
                          print("Values is: ");
                        },
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildTopPart(ThemeData theme) {
    return Row(
      children: [
        SizedBox(width: 15),
        Text(
          "User Management",
          style: theme.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: CupertinoColors.systemGrey3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                MaterialButton(
                  elevation: 0.0,
                  color: Colors.teal,
                  hoverColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.teal),
                  ),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    if (_activityOverlay != null) {
                      if (_activityOverlay.isVisible()) {
                        debugPrint("Activity overlay is not visible");

                        _animationController
                            .reverse()
                            .whenComplete(() => _activityOverlay.remove());
                        isActivityOpened.value = false;
                      } else {
                        debugPrint("Activity overlay is visible");
                        isActivityOpened.value = true;
                        _animationController.forward();
                        _activityOverlay.show();
                      }
                    } else {
                      debugPrint("Activity overlay is null");
                    }
                  },
                ),
                SizedBox(width: 10),
                MaterialButton(
                  elevation: 0.0,
                  color: Colors.teal,
                  hoverColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.teal),
                  ),
                  child: Text(
                    "Export",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: SizedBox(),
          onPressed: () {},
        ),
      ],
    );
  }
}

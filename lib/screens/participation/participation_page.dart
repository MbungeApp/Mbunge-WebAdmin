import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/webinar/webinar_cubit.dart';
import 'package:mbungeweb/models/webinar.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/screens/participation/widgets/edit_webinar_page.dart';
import 'package:mbungeweb/widgets/activity_overlay.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/page_route_transition.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

import 'widgets/livestream.dart';
import 'widgets/add_webinar_page.dart';

class ParticipationPage extends StatefulWidget {
  @override
  _ParticipationPageState createState() => _ParticipationPageState();
}

class _ParticipationPageState extends State<ParticipationPage>
    with SingleTickerProviderStateMixin {
  WebinarCubit _webinarCubit;
  ActivityOverlay _activityOverlay;
  AnimationController _animationController;
  ScrollController scrollController = ScrollController();
  ValueNotifier<bool> isActivityOpened = ValueNotifier(false);

  @override
  void initState() {
    _webinarCubit = WebinarCubit(
      webinarRepo: WebinarRepo(),
    );
    _webinarCubit.fetchWebinars();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _activityOverlay = ActivityOverlay(
      context,
      AddWebinarPage(
        webinarCubit: _webinarCubit,
        controller: _animationController,
        close: () {
          isActivityOpened.value = false;
          _animationController.reverse().whenComplete(() {
            _activityOverlay?.remove();
          });
        },
      ),
    );
    super.initState();
    isActivityOpened.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _webinarCubit?.close();
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
          create: (context) => _webinarCubit,
          child: ClipRRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 28),
                    buildTopPart(theme),
                    SizedBox(height: 28),
                    Flexible(
                      child: BlocConsumer(
                        cubit: _webinarCubit,
                        listener: (context, state) {
                          if (state is WebinarSuccess) {
                            if (state.webinarSuccessAction.message != "") {
                              Fluttertoast.showToast(
                                msg: state.webinarSuccessAction.message,
                              );
                            }
                            if (state.webinarSuccessAction.message
                                .contains("successfully")) {
                              if (_activityOverlay.isVisible()) {
                                _animationController.reverse().whenComplete(() {
                                  _activityOverlay?.remove();
                                  isActivityOpened.value = false;
                                });
                              }
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is WebinarInitial) {
                            return LoadingWidget();
                          }
                          if (state is WebinarError) {
                            return CustomErrorWidget(
                              child: Text(state.message),
                            );
                          }
                          if (state is WebinarSuccess) {
                            final webinars = state.webinars;
                            return buildDataTable(webinars);
                          }
                          return Container();
                        },
                      ),
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

  Widget buildDataTable(List<WebinarModel> webinars) {
    List<String> _columns = [
      "Index",
      "Agenda",
      "Guest",
      "Duration",
      "Postponed",
      "Scheduled At",
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
                    for (int i = 0; i < webinars.length; i++)
                      DataRow(
                        selected: i % 2 == 0 ? true : false,
                        cells: [
                          DataCell(Text("$i")),
                          DataCell(Text("${webinars[i].agenda}")),
                          DataCell(Text("${webinars[i].hostedBy}")),
                          DataCell(Text("${webinars[i].duration}")),
                          DataCell(Text("${webinars[i].postponed}")),
                          DataCell(Text(
                            "${DateFormat.yMEd().format(webinars[i].scheduleAt ?? DateTime.now())}",
                          )),
                          DataCell(Text(
                            "${DateFormat.yMEd().format(webinars[i].createdAt ?? DateTime.now())}",
                          )),
                          DataCell(
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text("Edit Webinar"),
                                  ),
                                  // PopupMenuItem(
                                  //   value: 'reschedule',
                                  //   child: Text("Reschedule Webinar"),
                                  // ),
                                  // PopupMenuItem(
                                  //   value: 'postponed',
                                  //   child: Text("Postponed Webinar"),
                                  // ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text("Delete Webinar"),
                                  ),
                                  PopupMenuItem(
                                    value: 'livestream',
                                    child: Text("Start Livestream"),
                                  )
                                ];
                              },
                              onSelected: (myValue) {
                                switch (myValue) {
                                  case 'edit':
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EditWebinarPage(
                                          webinarCubit: _webinarCubit,
                                          webinarModel: webinars[i],
                                        );
                                      },
                                    );
                                    break;
                                  case 'delete':
                                    _webinarCubit.deleteWebinar(webinars[i].id);
                                    break;
                                  case 'livestream':
                                    Navigator.push(
                                      context,
                                      PageRoutes.slide(
                                        () => LivestreamPage(
                                          webinarId: webinars[i].id,
                                          agenda: webinars[i].agenda,
                                        ),
                                      ),
                                    );
                                    break;
                                  default:
                                    debugPrint("error");
                                }
                              },
                            ),
                          ),
                        ],
                        onSelectChanged: (value) {
                          return null;
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
          "Online Webinars",
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
                // SizedBox(width: 10),
                // MaterialButton(
                //   elevation: 0.0,
                //   color: Colors.teal,
                //   hoverColor: Colors.white,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     side: BorderSide(color: Colors.teal),
                //   ),
                //   child: Text(
                //     "Export",
                //     style: TextStyle(
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                //   onPressed: () {},
                // ),
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

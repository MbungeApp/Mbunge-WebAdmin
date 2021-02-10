import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/mp/mp_cubit.dart';
import 'package:mbungeweb/models/mp_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/screens/mps/widgets/mp_item.dart';
import 'package:mbungeweb/widgets/activity_overlay.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

import 'widgets/add_mp_page.dart';

class MpPage extends StatefulWidget {
  @override
  _MpPageState createState() => _MpPageState();
}

class _MpPageState extends State<MpPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  MpCubit _mpCubit;
  ActivityOverlay _activityOverlay;
  ValueNotifier<bool> isActivityOpened = ValueNotifier(false);
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _mpCubit = MpCubit(mpRepo: MpRepo());
    _mpCubit.fetchAllMps();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _activityOverlay = ActivityOverlay(
      context,
      AddMpPage(
        mpCubit: _mpCubit,
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
    _mpCubit?.close();
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
          create: (context) => _mpCubit,
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
                      cubit: _mpCubit,
                      listener: (context, state) {
                        if (state is MpSuccess) {
                          Fluttertoast.showToast(
                            msg: state.actionState.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is MpInitial) {
                          return LoadingWidget();
                        }
                        if (state is MpError) {
                          return CustomErrorWidget(
                            child: Text(state.message),
                          );
                        }
                        if (state is MpSuccess) {
                          final mps = state.mps;
                          if (mps.isEmpty) {
                            return CustomErrorWidget(
                              child: Text("MPs are empty, please add some"),
                            );
                          }
                          return Flexible(
                            child: buildDataTable(mps),
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

  Widget buildDataTable(List<MpModel> mps) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      child: ScrollbarListStack(
        controller: scrollController,
        barSize: 10,
        axis: Axis.vertical,
        child: GridView.builder(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: mps.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            MpModel mp = mps[index];
            return MpItem(
              mp: mp,
              mpCubit: _mpCubit,
            );
          },
        ),
      ),
    );
  }

  Widget buildTopPart(ThemeData theme) {
    return Row(
      children: [
        SizedBox(width: 15),
        Text(
          "Member of Parliament",
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
                        _animationController.reverse().whenComplete(
                              () => _activityOverlay.remove(),
                            );
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
        SizedBox(width: 20),
      ],
    );
  }
}

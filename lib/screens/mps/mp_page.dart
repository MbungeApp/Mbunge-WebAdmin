import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/mp/mp_cubit.dart';
import 'package:mbungeweb/models/add_mp.dart';
import 'package:mbungeweb/models/mp_model.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/screens/mps/widgets/mp_item.dart';
import 'package:mbungeweb/utils/asset_picker.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/activity_overlay.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

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

class AddMpPage extends StatefulWidget {
  final Function close;
  final AnimationController controller;
  final MpCubit mpCubit;

  const AddMpPage({
    Key key,
    @required this.close,
    @required this.controller,
    @required this.mpCubit,
  }) : super(key: key);

  @override
  _AddMpPageState createState() => _AddMpPageState();
}

class _AddMpPageState extends State<AddMpPage> {
  AnimationController get _animationController => widget.controller;
  MpCubit get _mpCubit => widget.mpCubit;
  AddMpModel addMpModel = AddMpModel();
  ScrollController scrollController = ScrollController();
  TextEditingController _dateController;
  TextEditingController _pictureController;
  final _formKey = GlobalKey<FormState>();
  List<String> martialStatus = [
    "single",
    "married",
    "divorce",
    "widow",
    "widower",
    "undisclosed"
  ];
  String status = "single";
  DateTime dateStandardFormat;
  @override
  void initState() {
    _animationController
      ..forward()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _dateController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _pictureController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _mpCubit,
      child: BlocListener(
        cubit: _mpCubit,
        listener: (context, state) {
          if (state is MpSuccess) {
            if (state.actionState.message.contains("Add mp successfully")) {
              widget.close();
            }
          }
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SizedBox(
              width: deviceSize.width * 0.3,
              height: (deviceSize.height * 0.7) * widget.controller.value,
              child: Material(
                color: theme.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Material(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Please enter mp details 😉",
                                  style: theme.textTheme.subtitle1
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                TextButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.close();
                                  },
                                )
                              ],
                            ),
                            Flexible(
                              child: ScrollbarListStack(
                                controller: scrollController,
                                barSize: 10,
                                axis: Axis.vertical,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 30),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Name"),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addMpModel.name = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("County"),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addMpModel.county = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Constituency"),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addMpModel.constituency = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Date of birth"),
                                      ),
                                      TextFormField(
                                        controller: _dateController,
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(
                                            FocusNode(),
                                          );
                                          DateTime datePicked =
                                              await _selectDate();
                                          setState(() {
                                            dateStandardFormat = datePicked;
                                          });
                                          _dateController.text =
                                              DateFormat.yMEd().format(
                                            datePicked,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addMpModel.dateOfBirth =
                                              dateStandardFormat;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Picture"),
                                      ),
                                      TextFormField(
                                        onTap: () async {
                                          await _attachImage();
                                        },
                                        controller: _pictureController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Bio"),
                                      ),
                                      TextFormField(
                                        minLines: 3,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Input cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addMpModel.bio = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Martial Status"),
                                      ),
                                      SizedBox(height: 10),
                                      Wrap(
                                        children: martialStatus.map(
                                          (String role) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                25,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    status = role;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Chip(
                                                    backgroundColor: status
                                                            .contains(role)
                                                        ? theme.primaryColor
                                                        : theme.chipTheme
                                                            .backgroundColor,
                                                    label: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 5.0,
                                                      ),
                                                      child: new Text(role),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(height: 20),
                                      InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            addMpModel.martialStatus = status;
                                            AppLogger.logVerbose(
                                                addMpModel.toJson().toString());
                                            _mpCubit.addMp(
                                              model: addMpModel,
                                              imageBytes: addMpModel.picture,
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: 5),
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addMpModel = null;
    _dateController?.dispose();
    _pictureController?.dispose();
    status = "single";
    super.dispose();
  }

  Future<DateTime> _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    AppLogger.logDebug("DateTime: $picked");
    return picked;
  }

  _attachImage() async {
    final result = await AssetPickerService.pickImage();
    if (result != null) {
      PlatformFile file = result.files.first;

      _pictureController.text = file.name;
      setState(() {
        addMpModel.picture = file.bytes;
      });
    } else {
      // User canceled the picker
    }
  }
}

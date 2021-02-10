import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/webinar/webinar_cubit.dart';
import 'package:mbungeweb/models/add_webinar.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

class AddWebinarPage extends StatefulWidget {
  final WebinarCubit webinarCubit;
  final AnimationController controller;
  final Function close;

  const AddWebinarPage(
      {Key key, this.webinarCubit, this.controller, this.close})
      : super(key: key);
  @override
  _AddWebinarPageState createState() => _AddWebinarPageState();
}

class _AddWebinarPageState extends State<AddWebinarPage> {
  TextEditingController _agendaController;
  TextEditingController _hostController;
  TextEditingController _descController;
  TextEditingController _durationController;
  TextEditingController _scheduleAtController;
  AnimationController get _animationController => widget.controller;
  ScrollController scrollController = ScrollController();
  WebinarCubit get _webinarCubit => widget.webinarCubit;
  AddWebinarModel addWebinarModel = AddWebinarModel();
  final _formKey = GlobalKey<FormState>();
  DateTime dateStandardFormat;
  bool isLoading = false;

  @override
  void initState() {
    _animationController
      ..forward()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _agendaController = TextEditingController();
    _hostController = TextEditingController();
    _descController = TextEditingController();
    _durationController = TextEditingController();
    _scheduleAtController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addWebinarModel = null;
    _agendaController?.dispose();
    _hostController?.dispose();
    _descController?.dispose();
    _durationController?.dispose();
    _scheduleAtController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _webinarCubit,
      child: BlocListener(
        cubit: _webinarCubit,
        listener: (context, state) {
          if (state is WebinarSuccess) {
            if (state.webinarSuccessAction.message
                .contains("Added successfully")) {
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
                                  "Please enter Webinar details",
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
                                        child: Text("Agenda"),
                                      ),
                                      TextFormField(
                                        controller: _agendaController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Agenda cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addWebinarModel.agenda = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Guest Speaker"),
                                      ),
                                      TextFormField(
                                        controller: _hostController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Guest cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addWebinarModel.hostedBy = value;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Duration"),
                                      ),
                                      TextFormField(
                                        controller: _durationController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Guest cannot be null";
                                          } else if (!isNumeric(value)) {
                                            return "Only numeric value allowed";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addWebinarModel.duration =
                                              int.parse(value);
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Scheduled at"),
                                      ),
                                      TextFormField(
                                        controller: _scheduleAtController,
                                        onTap: () async {
                                          FocusScope.of(context).requestFocus(
                                            FocusNode(),
                                          );
                                          DateTime datePicked =
                                              await _selectDate();
                                          setState(() {
                                            dateStandardFormat = datePicked;
                                          });
                                          _scheduleAtController.text =
                                              DateFormat.yMMMMd().format(
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
                                            return "Schedule cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addWebinarModel.scheduleAt =
                                              dateStandardFormat;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Description"),
                                      ),
                                      TextFormField(
                                        minLines: 3,
                                        maxLines: null,
                                        controller: _descController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Description cannot be null";
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          addWebinarModel.description = value;
                                        },
                                      ),
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
                                            child: isLoading
                                                ? ButtonLoader()
                                                : Text(
                                                    "Add",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        ),
                                        onTap: isLoading
                                            ? null
                                            : () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  _formKey.currentState.save();

                                                  AppLogger.logVerbose(
                                                    addWebinarModel
                                                        .toJson()
                                                        .toString(),
                                                  );
                                                  _webinarCubit.addWebinar(
                                                    addWebinarModel,
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

  Future<DateTime> _selectDate() async {
    DateTime picked;
    DateTime pickedUnformatted = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 30)),
      cancelText: "It's a must field",
    );

    TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      cancelText: "It's a must",
    );
    if (timeOfDay != null && pickedUnformatted != null) {
      AppLogger.logDebug("Time: $timeOfDay");
      picked = DateTime(
        pickedUnformatted.year,
        pickedUnformatted.month,
        pickedUnformatted.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );
    }

    AppLogger.logDebug("DateTime: $picked");
    return picked ?? null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/webinar/webinar_cubit.dart';
import 'package:mbungeweb/models/edit_webinar.dart';
import 'package:mbungeweb/models/webinar.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';
import 'package:mbungeweb/widgets/toast.dart';

class EditWebinarPage extends StatefulWidget {
  final WebinarModel webinarModel;
  final WebinarCubit webinarCubit;

  const EditWebinarPage({
    Key key,
    this.webinarModel,
    this.webinarCubit,
  }) : super(key: key);
  @override
  _EditWebinarPageState createState() => _EditWebinarPageState();
}

class _EditWebinarPageState extends State<EditWebinarPage> {
  TextEditingController _dateController;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  EditWebinarModel editWebinarModel = EditWebinarModel();
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  DateTime dateStandardFormat;

  @override
  void initState() {
    isLoading.addListener(() {
      setState(() {});
    });
    _dateController = TextEditingController(
      text: DateFormat.yMEd().format(
        widget.webinarModel.scheduleAt ?? DateTime.now(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      cubit: widget.webinarCubit,
      listener: (context, state) {
        if (state is WebinarSuccess) {
          if (state.webinarSuccessAction.message.contains("Edited")) {
            Navigator.pop(context);
            CustomToast.showToast(
              message: "${state.webinarSuccessAction.message}",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
          } else {
            CustomToast.showToast(
              message: "${state.webinarSuccessAction.message}",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
            isLoading.value = false;
          }
        }
      },
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Edit Webinar"),
            TextButton.icon(
              label: Text("Close"),
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        content: SizedBox(
          width: size.width * 0.4,
          height: size.height * 0.7,
          child: Form(
            key: _formKey,
            child: ScrollbarListStack(
              controller: scrollController,
              barSize: 10,
              axis: Axis.vertical,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Agenda",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.webinarModel.agenda,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editWebinarModel.agenda = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Hosted By",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.webinarModel.hostedBy,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editWebinarModel.hostedBy = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Duration (hrs)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.webinarModel.duration.toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Duration cannot be null";
                          } else if (!isNumeric(value)) {
                            return "Only numeric value allowed";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          int duration = int.parse(value);
                          editWebinarModel.duration = duration;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Postponed Session",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: DropdownButtonFormField(
                        value: widget.webinarModel.postponed.toString(),
                        items: ["true", "false"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String value) {},
                        onSaved: (String value) {
                          if (value.toLowerCase().contains("true")) {
                            editWebinarModel.postponed = true;
                          } else {
                            editWebinarModel.postponed = false;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Schedule At",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        controller: _dateController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          );
                          DateTime datePicked = await _selectDate();
                          setState(() {
                            dateStandardFormat = datePicked;
                          });
                          _dateController.text = DateFormat.yMMMMd().format(
                            datePicked,
                          );
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editWebinarModel.scheduleAt = dateStandardFormat;

                          if (dateStandardFormat == null) {
                            editWebinarModel.scheduleAt = DateTime.now();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.webinarModel.description,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editWebinarModel.description = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: isLoading.value ? ButtonLoader() : Text("Edit"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            isLoading.value = true;

                            AppLogger.logDebug(
                                editWebinarModel.toJson().toString());
                            widget.webinarCubit.editWebinar(
                              widget.webinarModel.id,
                              editWebinarModel,
                            );
                          }
                        },
                      ),
                    )
                  ],
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

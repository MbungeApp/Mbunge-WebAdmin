import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/mp/mp_cubit.dart';
import 'package:mbungeweb/models/edit_mp.dart';
import 'package:mbungeweb/models/mp_model.dart';
import 'package:mbungeweb/utils/constants.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';
import 'package:mbungeweb/widgets/toast.dart';

class EditMpPage extends StatefulWidget {
  final MpModel mp;
  final MpCubit mpCubit;

  const EditMpPage({Key key, this.mp, this.mpCubit}) : super(key: key);
  @override
  _EditMpPageState createState() => _EditMpPageState();
}

class _EditMpPageState extends State<EditMpPage> {
  TextEditingController _dateController;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  EditMpModel editMpModel = EditMpModel();
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
        widget.mp.dateBirth ?? DateTime.now(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      cubit: widget.mpCubit,
      listener: (context, state) {
        if (state is MpSuccess) {
          if (state.actionState.message.contains("Edited")) {
            Navigator.pop(context);
            CustomToast.showToast(
              message: "${state.actionState.message}",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
          } else {
            CustomToast.showToast(
              message: "${state.actionState.message}",
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
            Text("Edit MP"),
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
                      "MP Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.mp.name,
                        decoration: InputDecoration(
                          hintText: "MP Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editMpModel.name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "MP Picture <not editable>",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        enabled: false,
                        maxLines: null,
                        initialValue: widget.mp.image,
                        decoration: InputDecoration(
                          hintText: "MP Picture",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          // medication.name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Martial Status",
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
                        initialValue: widget.mp.martialStatus,
                        decoration: InputDecoration(
                          hintText: "Martial Status",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editMpModel.martialStatus = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "County",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: DropdownButtonFormField(
                        value: widget.mp.county,
                        hint: Text("Select county"),
                        items: AppConstants.counties.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          
                        },
                        onSaved: (value) {
                          editMpModel.county = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                      //  TextFormField(
                      //   maxLines: null,
                      //   initialValue: widget.mp.county,
                      //   decoration: InputDecoration(
                      //     hintText: "County",
                      //     border: OutlineInputBorder(
                      //       borderSide: BorderSide(),
                      //     ),
                      //   ),
                      //   onSaved: (String value) {
                      //     editMpModel.county = value;
                      //   },
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Constituency",
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
                        initialValue: widget.mp.constituency,
                        decoration: InputDecoration(
                          hintText: "Constituency",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editMpModel.constituency = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Date of Birth",
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
                          hintText: "Date of Birth",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editMpModel.dateOfBirth = dateStandardFormat;

                          if (dateStandardFormat == null) {
                            editMpModel.dateOfBirth = DateTime.now();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Event Body",
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
                        initialValue: widget.mp.bio,
                        decoration: InputDecoration(
                          hintText: "Event Body",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editMpModel.bio = value;
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
                            editMpModel.picture = widget.mp.image;

                            AppLogger.logDebug(editMpModel.toJson().toString());
                            widget.mpCubit.editMp(
                              widget.mp.id,
                              editMpModel,
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
    DateTime pickedUnformatted = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 30)),
      cancelText: "It's a must field",
    );

    AppLogger.logDebug("DateTime: $pickedUnformatted");
    AppLogger.logDebug("DateTime: ${pickedUnformatted.toIso8601String()}");
    return pickedUnformatted ?? null;
  }
}

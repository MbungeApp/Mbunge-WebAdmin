import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/mp/mp_cubit.dart';
import 'package:mbungeweb/models/add_mp.dart';
import 'package:mbungeweb/utils/asset_picker.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/utils/constants.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

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
  String county = "";
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
                                  "Please enter mp details",
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
                                      // DropdownButtonFormField(
                                      //   value: county,
                                      //   hint: Text("Select county"),
                                      //   items: AppConstants.counties
                                      //       .map((String value) {
                                      //     return DropdownMenuItem<String>(
                                      //       value: value,
                                      //       child: Text(
                                      //         value,
                                      //       ),
                                      //     );
                                      //   }).toList(),
                                      //   onChanged: (String value) {
                                      //     setState(() {
                                      //       county = value;
                                      //     });
                                      //   },
                                      //   onSaved: (value) {
                                      //     addMpModel.county = value;
                                      //   },
                                      //   decoration: InputDecoration(
                                      //     border: OutlineInputBorder(
                                      //       borderSide: BorderSide(),
                                      //     ),
                                      //   ),
                                      // ),
                                      // TextFormField(
                                      //   decoration: InputDecoration(
                                      //     border: OutlineInputBorder(
                                      //       borderSide: BorderSide(),
                                      //     ),
                                      //   ),
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return "Input cannot be null";
                                      //     }
                                      //     return null;
                                      //   },
                                      //   onSaved: (value) {
                                      //     addMpModel.county = value;
                                      //   },
                                      // ),
                                      SizedBox(
                                        height: 60,
                                        child: ListView.builder(
                                          itemCount:
                                              AppConstants.counties.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 5.0,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    county = AppConstants
                                                        .counties[index];
                                                  });
                                                },
                                                child: Chip(
                                                  backgroundColor: county ==
                                                          AppConstants
                                                              .counties[index]
                                                      ? theme.primaryColor
                                                      : theme.chipTheme
                                                          .backgroundColor,
                                                  label: Text(
                                                    AppConstants
                                                        .counties[index],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
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
                                              child: GestureDetector(
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
                                                      child: Text(role),
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
                                            addMpModel.county = county;
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

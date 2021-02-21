import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/cubit/Events/events_cubit.dart';
import 'package:mbungeweb/models/add_event.dart';
import 'package:mbungeweb/utils/asset_picker.dart';
import 'package:mbungeweb/widgets/loading.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({
    Key key,
    @required this.close,
    @required this.controller,
    @required this.eventsCubit,
  }) : super(key: key);

  final EventsCubit eventsCubit;
  final Function close;
  final AnimationController controller;
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEventPage> {
  TextEditingController _nameController;
  TextEditingController _pictureController;
  TextEditingController _bodyController;
  AnimationController get _animationController => widget.controller;
  EventsCubit get _eventsCubit => widget.eventsCubit;
  AddEventModel addEventModel = AddEventModel();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _animationController
      ..forward()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    isLoading.addListener(() {
      setState(() {});
    });
    _nameController = TextEditingController();
    _pictureController = TextEditingController();
    _bodyController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addEventModel = null;
    _nameController?.dispose();
    _pictureController?.dispose();
    _bodyController?.dispose();
    isLoading?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _eventsCubit,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: SizedBox(
            width: deviceSize.width * 0.3,
            height: (deviceSize.height * 0.65) * widget.controller.value,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Please enter Event/News details",
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
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Name"),
                                  ),
                                  TextFormField(
                                    controller: _nameController,
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
                                      addEventModel.name = value;
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
                                    child: Text("Body"),
                                  ),
                                  TextFormField(
                                    maxLines: null,
                                    minLines: 3,
                                    controller: _bodyController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                    ),
                                    validator: (value) {
                                      print("called: $value");
                                      if (value == null) {
                                        return "Input cannot be null";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      addEventModel.body = value;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  InkWell(
                                    child: Container(
                                      width: double.infinity,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: isLoading.value
                                            ? ButtonLoader()
                                            : Text(
                                                "Add",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (_formKey.currentState.validate()) {
                                        isLoading.value = true;
                                        _formKey.currentState.save();
                                        _eventsCubit.addAnEvent(
                                          model: addEventModel,
                                          imageBytes: addEventModel.picture,
                                        );
                                      }
                                      // widget.close();
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
    );
  }

  _attachImage() async {
    final result = await AssetPickerService.pickImage();
    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.size);
      // print(file.bytes);
      print(file.extension);
      print(file.path);
      _pictureController.text = file.name;
      setState(() {
        addEventModel.picture = file.bytes;
      });
    } else {
      // User canceled the picker
    }
  }
}

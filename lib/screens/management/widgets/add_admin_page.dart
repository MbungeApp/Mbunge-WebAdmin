import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/cubit/admin/admin_cubit.dart';
import 'package:mbungeweb/models/add_admin.dart';

class AddAdminPage extends StatefulWidget {
  final Function close;
  final AnimationController controller;
  final AdminCubit adminCubit;

  const AddAdminPage({
    Key key,
    @required this.close,
    @required this.controller,
    @required this.adminCubit,
  }) : super(key: key);

  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  AnimationController get _animationController => widget.controller;
  AdminCubit get _adminCubit => widget.adminCubit;
  AddAdminModel addAdminModel = AddAdminModel();
  final _formKey = GlobalKey<FormState>();
  List<String> roles = ["0", "1", "2", "3", "4"];
  String role = "1";

  @override
  void initState() {
    _animationController
      ..forward()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    addAdminModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size deviceSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _adminCubit,
      child: BlocListener(
        cubit: _adminCubit,
        listener: (context, state) {
          if (state is AdminSuccess) {
            if (state.actionState.message == "Added admin") {
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
                                  "Please enter user details 😉",
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                        addAdminModel.name = value;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("National Id"),
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
                                        addAdminModel.nationalId = value;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Email Address"),
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
                                        addAdminModel.emailAddress = value;
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Role"),
                                    ),
                                    Wrap(
                                      children: roles.map((String role) {
                                        return Chip(
                                          label: new Text(role),
                                        );
                                      }).toList(),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          addAdminModel.role = 0;
                                          _adminCubit.addAdmin(addAdminModel);
                                        }
                                      },
                                    ),
                                    SizedBox(height: 5),
                                  ],
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/Events/events_cubit.dart';
import 'package:mbungeweb/models/edit_event.dart';
import 'package:mbungeweb/models/event.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';
import 'package:mbungeweb/widgets/toast.dart';

class EditEventPage extends StatefulWidget {
  final EventModel eventModel;
  final EventsCubit eventsCubit;
  const EditEventPage({
    Key key,
    @required this.eventModel,
    @required this.eventsCubit,
  }) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  EditEventModel editEventModel = EditEventModel();
  final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    isLoading.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener(
      cubit: widget.eventsCubit,
      listener: (context, state) {
        if (state is EventsSuccess) {
          if (state.eventActionState.message.contains("Edited")) {
            Navigator.pop(context);
            CustomToast.showToast(
              message: "${state.eventActionState.message}",
              type: Types.error,
              toastGravity: ToastGravity.BOTTOM_RIGHT,
            );
          } else {
            isLoading.value = false;
          }
        }
      },
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Edit Event"),
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Event Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        maxLines: null,
                        initialValue: widget.eventModel.name,
                        decoration: InputDecoration(
                          hintText: "Event Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editEventModel.name = value;
                          // medication.name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Event Picture",
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
                        initialValue: widget.eventModel.picture,
                        decoration: InputDecoration(
                          hintText: "Event Picture",
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
                        initialValue: widget.eventModel.body,
                        decoration: InputDecoration(
                          hintText: "Event Body",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onSaved: (String value) {
                          editEventModel.body = value;
                          // medication.prescription = value;
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
                            editEventModel.picture = widget.eventModel.picture;

                            AppLogger.logDebug(
                                editEventModel.toJson().toString());
                            widget.eventsCubit.editEvent(
                              widget.eventModel.id,
                              editEventModel,
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
}

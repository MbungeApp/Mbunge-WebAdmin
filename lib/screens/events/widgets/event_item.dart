import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/Events/events_cubit.dart';
import 'package:mbungeweb/models/edit_event.dart';
import 'package:mbungeweb/models/event.dart';
import 'package:mbungeweb/utils/logger.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/toast.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    Key key,
    @required this.eventModel,
    @required this.eventsCubit,
  }) : super(key: key);

  final EventsCubit eventsCubit;
  final EventModel eventModel;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                kIsWeb
                    ? "https://cors.mbungeapp.tech/${eventModel.picture}"
                    //  ? "https://thingproxy.freeboard.io/fetch/${eventModel.picture}"
                    : eventModel.picture,
                fit: BoxFit.cover,
                width: double.infinity,
                height: size.height * 0.21,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  eventModel.name,
                  style: theme.textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  "Tue Oct 13 2020",
                  style: theme.textTheme.subtitle2.copyWith(
                    color: theme.textTheme.subtitle2.color.withOpacity(0.6),
                    fontSize: theme.textTheme.subtitle2.fontSize * 0.8,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  eventModel.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(width: 10),
                  TextButton.icon(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditEventPage(
                            eventsCubit: eventsCubit,
                            eventModel: eventModel,
                          );
                        },
                      );
                    },
                    label: Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      eventsCubit.deleteEvent(eventModel.id);
                    },
                    label: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    isLoading.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Edit Event"),
        content: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                      ),
                      onSaved: (String value) {
                        editEventModel.name = value;
                        // medication.name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: TextFormField(
                      enabled: false,
                      initialValue: widget.eventModel.picture,
                      decoration: InputDecoration(
                        hintText: "Event Picture",
                      ),
                      onSaved: (String value) {
                        // medication.name = value;
                      },
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
          ],
        ),
      ),
    );
  }
}

import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/cubit/Events/events_cubit.dart';
import 'package:mbungeweb/models/event.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/screens/events/widgets/add_event.dart';
import 'package:mbungeweb/widgets/activity_overlay.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

import 'widgets/event_item.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ScrollController scrollController = ScrollController();
  ActivityOverlay _activityOverlay;
  ValueNotifier<bool> isActivityOpened = ValueNotifier(false);
  EventsCubit _eventsCubit;
  @override
  void initState() {
    _eventsCubit = EventsCubit(
      eventsRepo: EventsRepo(),
    );
    _eventsCubit.fetchEvents();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _activityOverlay = ActivityOverlay(
      context,
      AddEventPage(
        eventsCubit: _eventsCubit,
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
    _eventsCubit?.close();
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
          create: (context) => _eventsCubit,
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
                      cubit: _eventsCubit,
                      listener: (context, state) {
                        if (state is EventsSuccess) {
                          if (state.eventActionState.message
                              .contains("Added successfully")) {
                            _animationController.reverse().whenComplete(() {
                              _activityOverlay?.remove();
                              isActivityOpened.value = false;
                            });
                          }
                          Fluttertoast.showToast(
                            msg: state.eventActionState.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is EventsInitial) {
                          return LoadingWidget();
                        }
                        if (state is EventsError) {
                          return CustomErrorWidget(
                            child: Text(state.message),
                          );
                        }
                        if (state is EventsSuccess) {
                          final events = state.events;
                          if (events.isEmpty) {
                            return CustomErrorWidget(
                              child: Text("Events are empty, please add some"),
                            );
                          }
                          return Flexible(
                            child: buildDataTable(events),
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

  Widget buildDataTable(List<EventModel> events) {
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
          itemCount: events.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            EventModel eventModel = events[index];
            return EventItem(
              eventModel: eventModel,
              eventsCubit: _eventsCubit,
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
          "Events & News",
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

                        _animationController
                            .reverse()
                            .whenComplete(() => _activityOverlay.remove());
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
                    // displayPersistentBottomSheet();
                  },
                ),
                // SizedBox(width: 10),
                // MaterialButton(
                //   elevation: 0.0,
                //   color: Colors.teal,
                //   hoverColor: Colors.white,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5),
                //     side: BorderSide(color: Colors.teal),
                //   ),
                //   child: Text(
                //     "Export",
                //     style: TextStyle(
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                //   onPressed: () async {
                //     final pdf = pw.Document();
                //     pdf.addPage(
                //       pw.Page(
                //         pageFormat: PdfPageFormat.a4,
                //         build: (pw.Context context) {
                //           return pw.Center(
                //             child: pw.Text("Hello World"),
                //           ); // Center
                //         },
                //       ),
                //     );
                //     var bytes = await pdf.save();
                //     final file = File(bytes, "example.pdf");

                //     debugPrint(file.relativePath);
                //     // Navigator.push(context,
                //     //     MaterialPageRoute(builder: (context) => Test()));
                //   },
                // ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: SizedBox(),
          onPressed: () {},
        ),
      ],
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: LoadingWidget(),
      ),
    );
  }
}

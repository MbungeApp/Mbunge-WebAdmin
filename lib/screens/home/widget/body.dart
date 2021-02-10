import 'package:flutter/material.dart';
import 'package:mbungeweb/screens/dashboard/dashboard_page.dart';
import 'package:mbungeweb/screens/events/events_page.dart';
import 'package:mbungeweb/screens/management/management_page.dart';
import 'package:mbungeweb/screens/mps/mp_page.dart';
import 'package:mbungeweb/screens/participation/participation_page.dart';

import 'keep_alive.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.currentIndex,
  }) : super(key: key);
  final int currentIndex;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: IndexedStack(
        index: widget.currentIndex,
        children: [
          KeepAlivePage(
            key: Key("DashboardPage"),
            child: DashboardPage(),
          ),
          KeepAlivePage(
            key: Key("ParticipationPage"),
            child: ParticipationPage(),
          ),
          KeepAlivePage(
            key: Key("MpPage"),
            child: MpPage(),
          ),
          KeepAlivePage(
            key: Key("EventsPage"),
            child: EventsPage(),
          ),
          KeepAlivePage(
            key: Key("ManagementPage"),
            child: ManagementPage(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/widgets/page_route_transition.dart';
import 'package:mbungeweb/widgets/scroll_bar.dart';

import 'livestream.dart';

class ParticipationPage extends StatefulWidget {
  @override
  _ParticipationPageState createState() => _ParticipationPageState();
}

class _ParticipationPageState extends State<ParticipationPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  int currentIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 28),
          buildTopPart(theme),
          SizedBox(height: 28),
          Flexible(child: buildDataTable()),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    List<String> _columns = [
      "Index",
      "Name",
      "Created At",
      "Expired At",
      "Posted By",
      "Sector",
      "Actions",
    ];
    return ScrollbarListStack(
      controller: scrollController,
      barSize: 10,
      axis: Axis.vertical,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: _columns.map((col) {
                    return DataColumn(
                      label: Text(
                        col,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      numeric: false,
                      onSort: (a, b) {},
                    );
                  }).toList(),
                  rows: [
                    for (int i = 0; i < 10; i++)
                      DataRow(
                        selected: i % 2 == 0 ? true : false,
                        cells: [
                          DataCell(Text("$i")),
                          DataCell(Text("Patrick Waweru")),
                          DataCell(Text("0727751832")),
                          DataCell(Text("21 Mar 2020")),
                          DataCell(Text("ksh. 100")),
                          DataCell(Text("individual")),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelectChanged: (value) {
                          Navigator.push(
                            context,
                            PageRoutes.slide(() => LivestreamPage()),
                          );
                          print("Values is: ");
                        },
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildTopPart(ThemeData theme) {
    return Row(
      children: [
        SizedBox(width: 15),
        Text(
          "Participation",
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
          child: CupertinoSlidingSegmentedControl(
            groupValue: currentIndex,
            children: <int, Widget>{
              0: Text(
                "View all",
                style: TextStyle(
                  color: currentIndex == 0
                      ? Colors.white
                      : CupertinoColors.systemGrey2,
                  fontSize: 15,
                ),
              ),
              1: Text(
                "Add",
                style: TextStyle(
                  fontSize: 15,
                  color: currentIndex == 1
                      ? Colors.white
                      : CupertinoColors.systemGrey2,
                ),
              ),
            },
            backgroundColor: Colors.transparent,
            thumbColor: theme.primaryColor,
            onValueChanged: (i) {
              setState(() {
                _tabController.index = i;
              });
            },
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(
            Icons.download_rounded,
          ),
          onPressed: () {},
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

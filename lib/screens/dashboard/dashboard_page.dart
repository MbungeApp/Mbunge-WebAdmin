import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbungeweb/models/metrics.dart';
import 'package:mbungeweb/repository/_repository.dart';
import 'package:mbungeweb/repository/shared_preference_repo.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:mbungeweb/cubit/metrics/metrics_cubit.dart';
import 'package:mbungeweb/screens/dashboard/widgets/dounut_pie.dart';
import 'package:mbungeweb/screens/dashboard/widgets/map.dart';
import 'package:mbungeweb/screens/dashboard/widgets/top_card.dart';
import 'package:mbungeweb/widgets/error.dart';
import 'package:mbungeweb/widgets/loading.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_row_column.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  MetricsCubit _metricsCubit;

  @override
  void initState() {
    _metricsCubit = MetricsCubit(
      metricsRepo: MetricsRepo(),
    );
    _metricsCubit.fetchMetrics();
    super.initState();
  }

  @override
  void dispose() {
    _metricsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return RepaintBoundary(
      child: BlocProvider(
        create: (context) => _metricsCubit,
        child: BlocConsumer(
          cubit: _metricsCubit,
          listener: (context, state) {
            // listener
            if (state is MetricsSuccess) {
              Fluttertoast.showToast(msg: "Loaded metrics");
            }
          },
          builder: (context, state) {
            if (state is MetricsInitial) {
              return LoadingWidget();
            }
            if (state is MetricsError) {
              return CustomErrorWidget(
                child: Text(state.message),
              );
            }
            if (state is MetricsSuccess) {
              final metrics = state.metrics;
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 28),
                    buildTopPart(theme),
                    buildStatistics(metrics),
                    buildCharts(metrics, theme, size)
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildCharts(Metrics metrics, ThemeData theme, Size deviceSize) {
    bool isMobile = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP);
    return Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 30.0,
        top: isMobile ? 40 : 20,
      ),
      child: ResponsiveRowColumn(
        rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(DESKTOP),
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        columnCrossAxisAlignment: CrossAxisAlignment.center,
        columnMainAxisSize: MainAxisSize.min,
        rowPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        columnPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        columnSpacing: 50,
        rowSpacing: 25,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: 2,
            rowFit: FlexFit.tight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: AnimatedOpacity(
                    opacity: 0.7,
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      "Gender Demography",
                      style: theme.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    height: 300,
                    width: isMobile ? deviceSize.width : deviceSize.width * 0.3,
                    child: DonutPieChart(
                      [
                        charts.Series<LinearSales, int>(
                          id: 'gender',
                          domainFn: (LinearSales sales, _) => sales.year,
                          measureFn: (LinearSales sales, _) => sales.sales,
                          data: [
                            LinearSales(
                              0,
                              metrics.genderRation.male ?? 0,
                              charts.MaterialPalette.blue.shadeDefault,
                            ),
                            LinearSales(
                              1,
                              metrics.genderRation.female ?? 0,
                              charts.MaterialPalette.pink.shadeDefault,
                            ),
                          ],
                          colorFn: (LinearSales ln, _) => ln.color,
                        )
                      ],
                      animate: false,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.pink,
                      ),
                      SizedBox(width: 5),
                      Text("Female: ${metrics.genderRation.female}"),
                      SizedBox(width: 20),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      Text("Male: ${metrics.genderRation.male}"),
                    ],
                  ),
                )
              ],
            ),
          ),
         
          ResponsiveRowColumnItem(
            rowFlex: 8,
            rowFit: FlexFit.tight,
            child: DrawMap(
              location: metrics.usersLocation
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatistics(Metrics metrics) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return ResponsiveRowColumn(
          rowColumn: !ResponsiveWrapper.of(context).isSmallerThan(DESKTOP),
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          columnMainAxisSize: MainAxisSize.min,
          rowPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          columnPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          columnSpacing: 15,
          rowSpacing: 15,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: TopCard(
                title: "Total Users",
                count: "${metrics.card.totalUsers}",
                icon: Icons.people,
              ),
            ),
            // SizedBox(width: 15),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: TopCard(
                title: "Online Webinars",
                count: "${metrics.card.totalParticipation}",
                icon: CupertinoIcons.book,
              ),
            ),
            // SizedBox(width: 15),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: TopCard(
                title: "Total Events",
                count: "${metrics.card.totalEvents}",
                icon: Icons.calendar_today,
              ),
            ),
            // SizedBox(width: 15),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              rowFit: FlexFit.tight,
              child: TopCard(
                title: "Total Responses",
                count: "${metrics.card.totalResponses}",
                icon: Icons.speed,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildTopPart(ThemeData theme) {
    return Row(
      children: [
        SizedBox(width: 15),
        Text(
          "Dashboard",
          style: theme.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.notification_important,
          ),
          onPressed: () async {
            SharedPreferenceRepo refs = SharedPreferenceRepo();
            await refs.setUserToken("test1234567890");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.adb,
          ),
          onPressed: () async {
            SharedPreferenceRepo refs = SharedPreferenceRepo();
            print("*********************************");
            print("******* ${await refs.getUserToken()} *****");
            print("*********************************");
          },
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

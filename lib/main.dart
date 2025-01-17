import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbungeweb/cubit/login/login_cubit.dart';
import 'package:mbungeweb/cubit/observer.dart';
// import 'package:mbungeweb/screens/account/login_page.dart';
import 'package:mbungeweb/utils/colors.dart';
import 'package:mbungeweb/utils/routes.dart';
import 'package:mbungeweb/widgets/restart_widget.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:statsfl/statsfl.dart';

import 'screens/decision.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(
    StatsFl(
      isEnabled: false,
      maxFps: 120,
      child: RestartWidget(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LoginCubit loginCubit;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return loginCubit;
      },
      child: MaterialApp(
        title: 'Mbunge Web Admin',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.whiteColor,
          primarySwatch: Colors.teal,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        builder: (context, widget) {
          return ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, widget),
            defaultScale: true,
            minWidth: 480,
            defaultName: MOBILE,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5)),
          );
        },
        home: DecisionPage(),
      ),
    );
  }
}

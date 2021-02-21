import 'package:flutter/material.dart';
import 'package:mbungeweb/models/user_model.dart';
import 'package:mbungeweb/screens/home/widget/body.dart';
import 'package:mbungeweb/screens/home/widget/sidebar.dart';

//token, userModel, loginCubit
class HomePage extends StatefulWidget {
  final String token;
  final UserModel userModel;
  const HomePage({
    Key key,
    @required this.token,
    @required this.userModel,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RestorationMixin {
  // PageController _pageController;
  final RestorableInt _currentIndex = RestorableInt(0);

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_currentIndex, 'page_view_index');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              flex: 2, //1
              child: Sidebar(
                userModel: widget.userModel,
                currentIndex: _currentIndex.value,
                onTap: (value) {
                  setState(() {
                    _currentIndex.value = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 10, //6
              child: Body(
                currentIndex: _currentIndex.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

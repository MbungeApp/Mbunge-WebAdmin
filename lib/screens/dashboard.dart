import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

class DashboarHome extends StatefulWidget {
  const DashboarHome({
    Key key,
  }) : super(key: key);

  @override
  _DashboarHomeState createState() => _DashboarHomeState();
}

class _DashboarHomeState extends State<DashboarHome> {
  GlobalKey<GoogleMapStateBase> _key = GlobalKey<GoogleMapStateBase>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 20,
          ),
          child: Text(
            "Dashboard | Home",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleTile(
                color: Colors.red,
                title: "Total Users",
                subtitle: "4500",
                icon: Icons.person,
              ),
              SingleTile(
                color: Colors.blue,
                title: "Total Events",
                subtitle: "100",
                icon: Icons.calendar_today,
              ),
              SingleTile(
                color: Colors.green,
                title: "Total Participations",
                subtitle: "5",
                icon: Icons.people,
              ),
              SingleTile(
                color: Colors.purple,
                title: "Total Responses",
                subtitle: "1000",
                icon: Icons.comment,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                        ),
                        child: Text(
                          "MP of the Week",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                  "https://picsum.photos/id/237/200/300"),
                              Text("Hon. Patrick Waweru"),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry." +
                                    " Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                        ),
                        child: Text(
                          "MP of the Week",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: GoogleMap(
                          key: _key,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class SingleTile extends StatelessWidget {
  const SingleTile({
    Key key,
    @required this.color,
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  width: 150,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: Icon(icon),
                ),
              ),
              Flexible(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(opacity: 0.7, child: Text(title)),
                      SizedBox(height: 10),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

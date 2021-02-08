import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String count;
  final String title;
  final IconData icon;

  const TopCard(
      {Key key,
      @required this.count,
      @required this.title,
      @required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                color: theme.primaryColor,
              ),
            ),
          ),
          subtitle: Text(count),
          trailing: Icon(
            icon,
            size: 30,
          ),
        ),
      ),
    );
  }
}

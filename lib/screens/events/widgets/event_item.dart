import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mbungeweb/cubit/Events/events_cubit.dart';
import 'package:mbungeweb/models/event.dart';

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
                  onPressed: () {},
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
    );
  }
}

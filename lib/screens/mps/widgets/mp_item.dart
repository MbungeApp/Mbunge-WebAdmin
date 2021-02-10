import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbungeweb/cubit/mp/mp_cubit.dart';
import 'package:mbungeweb/models/mp_model.dart';

class MpItem extends StatelessWidget {
  const MpItem({
    Key key,
    @required this.mp,
    @required this.mpCubit,
  }) : super(key: key);

  final MpModel mp;
  final MpCubit mpCubit;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width * 0.192,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                kIsWeb ? "https://cors.mbungeapp.tech/${mp.image}" : mp.image,
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
                  "${mp.name}",
                  style: theme.textTheme.subtitle1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 8.0,
                ),
                child: Text(
                  DateFormat.yMEd().format(mp.dateBirth ?? DateTime.now()),
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
                  mp.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
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
                      mpCubit.deleteMp(mp.id);
                    },
                    label: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

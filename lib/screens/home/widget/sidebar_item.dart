import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String title;
  final Function onTap;

  const SidebarItem({
    Key key,
    @required this.isActive,
    @required this.icon,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 18.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextButton(
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.teal.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    icon,
                    color: isActive ? Colors.teal : Colors.black54,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.black54,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

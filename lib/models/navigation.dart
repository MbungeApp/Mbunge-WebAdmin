import 'package:flutter/material.dart';

class SideBar {
  final IconData icon;
  final String title;

  SideBar({
    @required this.icon,
    @required this.title,
  });
}

List<SideBar> sidebarData = [
  SideBar(
    title: "Dashboard",
    icon: Icons.speed,
  ),
  SideBar(
    title: "Participation",
    icon: Icons.bookmark,
  ),
  SideBar(
    title: "MPs",
    icon: Icons.star,
  ),
  SideBar(
    title: "Events",
    icon: Icons.calendar_today,
  ),
  SideBar(
    title: "User Management",
    icon: Icons.person,
  ),
];

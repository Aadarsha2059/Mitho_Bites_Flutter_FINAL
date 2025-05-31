import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class MenuModel {
  List<MenuItem> getMenuItems(BuildContext context) {
    return [
      MenuItem(
        title: 'Home',
        icon: Icons.home,
        onTap: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
      MenuItem(
        title: 'Profile',
        icon: Icons.person,
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
      MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        onTap: () {
          Navigator.pushNamed(context, '/settings');
        },
      ),
      MenuItem(
        title: 'Logout',
        icon: Icons.logout,
        onTap: () {
          Navigator.popUntil(context, ModalRoute.withName('/login'));
        },
      ),
    ];
  }
}

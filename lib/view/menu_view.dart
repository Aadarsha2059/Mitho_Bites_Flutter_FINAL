import 'package:flutter/material.dart';
import 'package:fooddelivery_b/model/menu_model.dart';


class MenuPage extends StatelessWidget {
  final model = MenuModel();

  @override
  Widget build(BuildContext context) {
    final menuItems = model.getMenuItems(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: const Color(0xff281537),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item.icon, color: Color(0xffB81736)),
            title: Text(
              item.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: item.onTap,
          );
        },
      ),
    );
  }
}

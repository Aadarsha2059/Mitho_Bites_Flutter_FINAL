import 'package:flutter/material.dart';

class DashboardModel extends ChangeNotifier {
  TextEditingController txtSearch = TextEditingController();
  int selectedIndex = 0;

  final List<Map<String, String>> catArr = [
    {"image": "assets/images/cat_offer.png", "name": "Burger"},
    {"image": "assets/images/cat_sri.png", "name": "Dal-Bhat"},
    {"image": "assets/images/cat_3.png", "name": "Chinese"},
    {"image": "assets/images/cat_4.png", "name": "Indian"},
  ];

  final List<Map<String, String>> popArr = [
    {"image": "assets/images/res_1.png", "name": "Koteshwor Rooftop"},
    {"image": "assets/images/res_2.png", "name": "Dillibazar Delicious"},
    {"image": "assets/images/res_3.png", "name": "Kapan Crunch Restro"},
  ];

  final List<Map<String, String>> mostPopArr = [
    {"image": "assets/images/m_res_1.png", "name": "Pizza"},
    {"image": "assets/images/m_res_2.png", "name": "Desserts"},
  ];

  final List<Map<String, String>> recentArr = [
    {"image": "assets/images/item_1.png", "name": "Chicken Mo:Mo"},
    {"image": "assets/images/item_2.png", "name": "Buff Sukuti Set"},
    {"image": "assets/images/item_3.png", "name": "Sel Roti & Aloo Tarkari"},
  ];

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void disposeControllers() {
    txtSearch.dispose();
  }
}

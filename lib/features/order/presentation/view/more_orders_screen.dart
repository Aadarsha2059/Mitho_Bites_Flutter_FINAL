import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/features/order/presentation/view/order_history_view.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';

class MoreOrdersScreen extends StatelessWidget {
  const MoreOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => serviceLocator<OrderViewModel>()..fetchOrders(),
      child: const OrderHistoryView(),
    );
  }
} 
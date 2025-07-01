import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';
import 'package:fooddelivery_b/features/order/domain/use_case/get_orders_usecase.dart';
import 'package:fooddelivery_b/features/order/domain/use_case/update_order_status_usecase.dart';

enum OrderStatusFilter { all, pending, received, cancelled }

class OrderViewModel extends ChangeNotifier {
  final GetOrdersUsecase _getOrdersUsecase;
  final UpdateOrderStatusUsecase _updateOrderStatusUsecase;
  final CancelOrderUsecase _cancelOrderUsecase;
  final MarkOrderReceivedUsecase _markOrderReceivedUsecase;

  List<OrderEntity> _orders = [];
  List<OrderEntity> get orders => _orders;

  OrderStatusFilter _filter = OrderStatusFilter.all;
  OrderStatusFilter get filter => _filter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;
  String? _updateError;
  String? get updateError => _updateError;

  OrderViewModel({
    required GetOrdersUsecase getOrdersUsecase,
    required UpdateOrderStatusUsecase updateOrderStatusUsecase,
    required CancelOrderUsecase cancelOrderUsecase,
    required MarkOrderReceivedUsecase markOrderReceivedUsecase,
  }) : _getOrdersUsecase = getOrdersUsecase,
       _updateOrderStatusUsecase = updateOrderStatusUsecase,
       _cancelOrderUsecase = cancelOrderUsecase,
       _markOrderReceivedUsecase = markOrderReceivedUsecase;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getOrdersUsecase();
    result.fold((failure) => _error = failure.message, (orders) {
      // Sort orders by orderDate descending
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      _orders = orders;
    });
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(OrderStatusFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  List<OrderEntity> get filteredOrders {
    switch (_filter) {
      case OrderStatusFilter.pending:
        return _orders.where((o) => o.orderStatus == 'pending').toList();
      case OrderStatusFilter.received:
        return _orders.where((o) => o.orderStatus == 'received').toList();
      case OrderStatusFilter.cancelled:
        return _orders.where((o) => o.orderStatus == 'cancelled').toList();
      case OrderStatusFilter.all:
      default:
        return _orders;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    _isUpdating = true;
    _updateError = null;
    notifyListeners();
    final result = await _updateOrderStatusUsecase(
      UpdateOrderStatusParams(orderId: orderId, status: status),
    );
    _isUpdating = false;
    if (result.isRight()) {
      await fetchOrders();
      notifyListeners();
      return true;
    } else {
      _updateError = result.fold((l) => l.message, (r) => null);
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    _isUpdating = true;
    _updateError = null;
    notifyListeners();
    final result = await _cancelOrderUsecase(orderId);
    _isUpdating = false;
    if (result.isRight()) {
      await fetchOrders();
      notifyListeners();
      return true;
    } else {
      _updateError = result.fold((l) => l.message, (r) => null);
      notifyListeners();
      return false;
    }
  }

  Future<bool> markOrderReceived(String orderId) async {
    _isUpdating = true;
    _updateError = null;
    notifyListeners();
    final result = await _markOrderReceivedUsecase(orderId);
    _isUpdating = false;
    if (result.isRight()) {
      await fetchOrders();
      notifyListeners();
      return true;
    } else {
      _updateError = result.fold((l) => l.message, (r) => null);
      notifyListeners();
      return false;
    }
  }
}

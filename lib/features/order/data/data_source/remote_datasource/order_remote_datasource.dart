import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/order/data/data_source/order_api_i_datasource.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';

class OrderRemoteDataSource implements IOrderRemoteDataSource {
  final ApiService _apiService;

  OrderRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<OrderEntity>> getAllOrders() async {
    final response = await _apiService.dio.get(ApiEndpoints.getUserOrders);
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        final List<dynamic> ordersData = responseData['data'];
        return ordersData.map((json) => OrderEntity.fromJson(json)).toList();
      } else if (responseData is List) {
        return responseData.map((json) => OrderEntity.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format from server');
      }
    } else {
      throw Exception('Failed to get orders: ${response.statusMessage}');
    }
  }

  @override
  Future<OrderEntity> getOrderById(String orderId) async {
    final response = await _apiService.dio.get('${ApiEndpoints.getOrderById}$orderId');
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData['success'] == true && responseData['data'] != null) {
        return OrderEntity.fromJson(responseData['data']);
      } else {
        throw Exception('Invalid response format from server');
      }
    } else {
      throw Exception('Failed to get order: ${response.statusMessage}');
    }
  }

  @override
  Future<void> createOrder(OrderEntity order) async {
    final response = await _apiService.dio.post(
      ApiEndpoints.createOrder,
      data: order.toJson(),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create order: ${response.statusMessage}');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    print('updateOrderStatus called with status: $status');
    status = status.toLowerCase(); // Ensure lowercase for matching
    String url;
    dynamic data;
    Options? options;
    if (status == 'cancelled') {
      url = '${ApiEndpoints.updateOrderStatus}$orderId/cancel';
      data = null;
      options = Options(contentType: null);
    } else if (status == 'received') {
      url = '${ApiEndpoints.updateOrderStatus}$orderId/received';
      data = null;
      options = Options(contentType: null);
    } else {
      url = '${ApiEndpoints.updateOrderStatus}$orderId';
      data = {'orderStatus': status};
      options = Options(contentType: Headers.jsonContentType);
    }
    final response = await _apiService.dio.put(
      url,
      data: data,
      options: options,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update order status: \\${response.statusMessage}');
    }
  }

  @override
  Future<void> updatePaymentStatus(String orderId, String paymentStatus) async {
    final response = await _apiService.dio.put(
      '${ApiEndpoints.updatePaymentStatus}$orderId/payment',
      data: {'paymentStatus': paymentStatus},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update payment status: ${response.statusMessage}');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    final url = '${ApiEndpoints.updateOrderStatus}$orderId/cancel';
    final response = await _apiService.dio.put(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to cancel order: \\${response.statusMessage}');
    }
  }

  @override
  Future<void> markOrderReceived(String orderId) async {
    final url = '${ApiEndpoints.updateOrderStatus}$orderId/received';
    final response = await _apiService.dio.put(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to mark order as received: \\${response.statusMessage}');
    }
  }
}
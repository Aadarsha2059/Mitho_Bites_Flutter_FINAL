import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/payment_datasource.dart';
import 'package:fooddelivery_b/features/payment/data/model/payment_api_model.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';


class PaymentRemoteDataSource implements IPaymentDataSource {
  final ApiService _apiService;
  
  PaymentRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createOrder,
        data: orderData,
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to create order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to create order: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUserOrders,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> ordersData = responseData['data'];
          return ordersData.cast<Map<String, dynamic>>();
        } else if (responseData is List) {
          return responseData.cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get user orders: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get user orders: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get user orders: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final response = await _apiService.dio.get(
        '${ApiEndpoints.getOrderById}$orderId',
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get order: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get order: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.updatePaymentStatus}$orderId/payment',
        data: {'paymentStatus': paymentStatus},
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to update payment status: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to update payment status: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to update payment status: $e');
    }
  }

  @override
  Future<PaymentMethodEntity> createPaymentRecord(PaymentMethodEntity paymentRecord) async {
    try {
      final paymentData = {
        'food': paymentRecord.food,
        'quantity': paymentRecord.quantity,
        'totalprice': paymentRecord.totalPrice,
        'paymentmode': paymentRecord.paymentMode,
      };

      final response = await _apiService.dio.post(
        ApiEndpoints.createPaymentRecord,
        data: paymentData,
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return PaymentApiModel.fromJson(responseData['data']).toEntity();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to create payment record: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to create payment record: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to create payment record: $e');
    }
  }

  @override
  Future<List<PaymentMethodEntity>> getAllPaymentRecords() async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllPaymentRecords,
      );
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> paymentData = responseData['data'];
          return paymentData
              .map((json) => PaymentApiModel.fromJson(json).toEntity())
              .toList();
        } else if (responseData is List) {
          return responseData
              .map((json) => PaymentApiModel.fromJson(json).toEntity())
              .toList();
        } else {
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception('Failed to get payment records: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to get payment records: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get payment records: $e');
    }
  }

  @override
  Future<void> savePaymentRecords(List<PaymentMethodEntity> paymentRecords) async {
    // Payment records are managed by backend, not by client
    throw UnimplementedError('Payment records are managed by backend');
  }

  @override
  Future<void> clearPaymentRecords() async {
    // Payment records are managed by backend, not by client
    throw UnimplementedError('Payment records are managed by backend');
  }
}
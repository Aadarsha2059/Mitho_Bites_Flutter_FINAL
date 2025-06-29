import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';


abstract interface class IPaymentDataSource {
  
  // Create order 
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData);
  
  // Get user's order history
  Future<List<Map<String, dynamic>>> getUserOrders();
  
  // Get specific order by ID
  Future<Map<String, dynamic>> getOrderById(String orderId);
  
  // Update payment status
  Future<Map<String, dynamic>> updatePaymentStatus(String orderId, String paymentStatus);
  
  // Store payment method record
  Future<PaymentMethodEntity> createPaymentRecord(PaymentMethodEntity paymentRecord);
  
  // Get all payment records (admin)
  Future<List<PaymentMethodEntity>> getAllPaymentRecords();
  
  // Save payment records locally (if needed)
  Future<void> savePaymentRecords(List<PaymentMethodEntity> paymentRecords);
  
  // Clear local payment records
  Future<void> clearPaymentRecords();
}
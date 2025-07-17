import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts - Reduced for faster response
  static const connectionTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);

  // Default for Android Emulator
  static const String _emulatorAddress = "http://10.0.2.2:5050";
  // For iOS Simulator
  static const String _iosSimulatorAddress = "http://localhost:5050";
  // For real device 
  static const String _realDeviceAddress = "http://192.168.1.80:5050"; // Use your actual local IP and port 5050 for real device

  static String get serverAddress {
    if (kIsWeb) {
      
      return _realDeviceAddress;
    }
    if (Platform.isAndroid) {
      // Check for emulator
      
      return _emulatorAddress;
    } else if (Platform.isIOS) {
    
      return _iosSimulatorAddress;
    } else {
      // Fallback for other platforms
      return _realDeviceAddress;
    }
  }

  static String get baseUrl => "$serverAddress/api/";
  static String get imageUrl => "$serverAddress/uploads/";

  // Auth - MERN Backend endpoints (CONFIRMED)
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getCurrentUser = "auth/me";
  static const String updateUser = "auth/update";
  
  // Public endpoints for categories and restaurants
  static const String getAllCategory = "categories";
  static const String getAllRestaurant = "restaurants";
  static const String getAllProducts = "products";
  static const String getCart = "cart";
  static const String addToCart = "cart/add";
  static const String updateCartItem = "cart/update";
  static const String removeFromCart = "cart/remove";
  static const String clearCart = "cart/clear";
  static const String getCartItem = "cart/item";
  // Payment endpoints
  static const String createOrder = "orders";
  static const String getUserOrders = "orders";
  static const String getOrderById = "orders/"; 
  static const String updatePaymentStatus = "orders/"; 
  // Payment method endpoints 
  static const String createPaymentRecord = "admin/paymentmethod";
  static const String getAllPaymentRecords = "admin/paymentmethod";
  //order method endpoints
  static const String cancelOrder = "orders/";          
  static const String markOrderReceived = "orders/";    
  static const String updateOrderStatus = "orders/"; 
  // Feedback endpoints 
  static const String getFeedbacksForProduct = "feedbacks/product/"; // GET /api/feedbacks/product/{productId}
  static const String getUserFeedbacks = "feedbacks/user";           // GET /api/feedbacks/user
  static const String submitFeedback = "feedbacks";                  // POST /api/feedbacks
  static const String getAllFeedbacks = "feedbacks";                 // GET /api/feedbacks
}

class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts - Reduced for faster response
  static const connectionTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);

  // For Android Emulator - Updated to correct port (MERN backend runs on 3000)
  static const String serverAddress = "http://10.0.2.2:5050";

  // For iOS Simulator
  //static const String serverAddress = "http://localhost:3000";

  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

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
  // static const String updatePaymentStatus = "order/";  
  static const String markOrderReceived = "orders/";    

  static const String updateOrderStatus = "orders/"; 

  // Feedback endpoints 
  static const String getFeedbacksForProduct = "feedbacks/product/"; // GET /api/feedbacks/product/{productId}
  static const String getUserFeedbacks = "feedbacks/user";           // GET /api/feedbacks/user
  static const String submitFeedback = "feedbacks";                  // POST /api/feedbacks
  static const String getAllFeedbacks = "feedbacks";                 // GET /api/feedbacks

}

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
  // Note: getAllUsers endpoint does not exist in MERN backend

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

  // Order endpoints (use these for all order-related API calls)
  static const String createOrder = "order";           // POST
  static const String getUserOrders = "order/user";    // GET (all orders for a user)
  static const String getOrderById = "order/";         // GET (single order by id, e.g., order/{id})
  static const String updateOrderStatus = "order/";    // PATCH/PUT (e.g., order/{id})

  // Payment method endpoints 
  static const String createPaymentRecord = "admin/paymentmethod";
  static const String getAllPaymentRecords = "admin/paymentmethod";
} 
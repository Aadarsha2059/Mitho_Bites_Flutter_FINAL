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
  // Note: getAllUsers endpoint does not exist in MERN backend

  // Public endpoints for categories and restaurants
  static const String getAllCategory = "categories";
  static const String getAllRestaurant = "restaurants";

  static const String getAllProducts = "products";
}

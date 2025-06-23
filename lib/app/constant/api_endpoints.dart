class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts - Fixed to reasonable values
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // For Android Emulator - Updated to correct port
  static const String serverAddress = "http://10.0.2.2:5050";

  // For iOS Simulator
  //static const String serverAddress = "http://localhost:5050";

  
  static const String baseUrl = "$serverAddress/api/";
  static const String imageUrl = "$serverAddress/uploads/";

  // Auth - MERN Backend endpoints (CONFIRMED)
  static const String login = "auth/login";
  static const String register = "auth/register";
  // Note: getAllUsers endpoint does not exist in MERN backend

  // admin 
  static const String getAllCategory = "admin/category/";
  
}

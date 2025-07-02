import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/user/data/model/user_hive_model.dart';
import 'package:fooddelivery_b/features/food_category/data/model/category_hive_model.dart';
import 'package:fooddelivery_b/features/restaurant/data/model/restaurant_hive_model.dart';
import 'package:fooddelivery_b/features/food_products/data/model/product_hive_model.dart';
import 'package:fooddelivery_b/features/cart/data/model/cart_hive_model.dart';
import 'package:fooddelivery_b/features/payment/data/model/payment_hive_model.dart';
import 'package:fooddelivery_b/features/order/data/model/order_hive_model.dart';
import 'package:fooddelivery_b/features/feedbacks/data/model/feedback_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HiveService {
  Future<void> init() async {
    // Ensure all old Hive data is cleared before registering adapters
    await Hive.deleteFromDisk();

    var directory = await getApplicationDocumentsDirectory();

    final hiveDbDir = Directory('${directory.path}/mydbb.db');
    if (!await hiveDbDir.exists()) {
      await hiveDbDir.create(recursive: true);
    }  

    Hive.init(hiveDbDir.path);

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      print('Registering UserHiveModelAdapter');
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      print('Registering CategoryHiveModelAdapter');
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      print('Registering RestaurantHiveModelAdapter');
      Hive.registerAdapter(RestaurantHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      print('Registering ProductHiveModelAdapter');
      Hive.registerAdapter(ProductHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      print('Registering CartItemHiveModelAdapter');
      Hive.registerAdapter(CartItemHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      print('Registering CartHiveModelAdapter');
      Hive.registerAdapter(CartHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      print('Registering PaymentHiveModelAdapter');
      Hive.registerAdapter(PaymentHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      print('Registering OrderHiveModelAdapter');
      Hive.registerAdapter(OrderHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      print('Registering FeedbackHiveModelAdapter');
      Hive.registerAdapter(FeedbackHiveModelAdapter());
    }

    // Open order box
    await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderBox);
    await Hive.openBox<FeedbackHiveModel>(HiveTableConstant.feedbackBox);
  }

  // User methods
  Future<void> register(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<UserHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  Future<UserHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    try {
      return box.values.firstWhere(
        (element) =>
            element.username == username && element.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Category methods
  Future<void> saveCategories(List<CategoryHiveModel> categories) async {
    var box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    await box.clear(); // Clear existing categories
    for (var category in categories) {
      await box.put(category.categoryId, category);
    }
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    return box.values.toList();
  }

  Future<void> clearCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    await box.clear();
  }

  Future<void> deleteCategory(String categoryId) async {
    var box = await Hive.openBox<CategoryHiveModel>(
      HiveTableConstant.categoryBox,
    );
    await box.delete(categoryId);
  }

  // Restaurant methods
  Future<void> saveRestaurants(List<RestaurantHiveModel> restaurants) async {
    var box = await Hive.openBox<RestaurantHiveModel>(
      HiveTableConstant.restaurantBox,
    );
    await box.clear();
    for (var restaurant in restaurants) {
      await box.put(restaurant.restaurantId, restaurant);
    }
  }

  Future<List<RestaurantHiveModel>> getAllRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(
      HiveTableConstant.restaurantBox,
    );
    return box.values.toList();
  }

  Future<void> clearRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(
      HiveTableConstant.restaurantBox,
    );
    await box.clear();
  }

  // Product methods
  Future<void> saveProducts(List<ProductHiveModel> products) async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.clear();
    for (var product in products) {
      await box.put(product.productId, product);
    }
  }

  Future<List<ProductHiveModel>> getAllProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    return box.values.toList();
  }

  Future<void> clearProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.clear();
  }

  Future<void> deleteProduct(String productId) async {
    var box = await Hive.openBox<ProductHiveModel>(
      HiveTableConstant.productBox,
    );
    await box.delete(productId);
  }

  // Cart methods
  Future<void> saveCartItems(List<CartItemHiveModel> cartItems) async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    await box.clear();
    for (var cartItem in cartItems) {
      await box.put(cartItem.cartItemId, cartItem);
    }
  }

  Future<List<CartItemHiveModel>> getAllCartItems() async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    return box.values.toList();
  }

  Future<void> clearCart() async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    await box.clear();
  }

  Future<void> addCartItem(CartItemHiveModel cartItem) async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    await box.put(cartItem.cartItemId, cartItem);
  }

  Future<void> updateCartItem(
    String cartItemId,
    CartItemHiveModel updatedCartItem,
  ) async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    await box.put(cartItemId, updatedCartItem);
  }

  Future<void> removeCartItem(String cartItemId) async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    await box.delete(cartItemId);
  }

  Future<CartItemHiveModel?> getCartItem(String cartItemId) async {
    var box = await Hive.openBox<CartItemHiveModel>(HiveTableConstant.cartBox);
    return box.get(cartItemId);
  }

  Future<void> saveCart(CartHiveModel cart) async {
    var box = await Hive.openBox<CartHiveModel>(HiveTableConstant.cartBox);
    await box.put(cart.cartId, cart);
  }

  Future<CartHiveModel?> getCart(String cartId) async {
    var box = await Hive.openBox<CartHiveModel>(HiveTableConstant.cartBox);
    return box.get(cartId);
  }

  Future<void> deleteCart(String cartId) async {
    var box = await Hive.openBox<CartHiveModel>(HiveTableConstant.cartBox);
    await box.delete(cartId);
  }

  // Payment methods
  Future<void> savePaymentRecords(List<PaymentHiveModel> paymentRecords) async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    await box.clear();
    for (var paymentRecord in paymentRecords) {
      await box.put(paymentRecord.id, paymentRecord);
    }
  }

  Future<List<PaymentHiveModel>> getAllPaymentRecords() async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    return box.values.toList();
  }

  Future<void> clearPaymentRecords() async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    await box.clear();
  }

  Future<void> addPaymentRecord(PaymentHiveModel paymentRecord) async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    await box.put(paymentRecord.id, paymentRecord);
  }

  Future<PaymentHiveModel?> getPaymentRecord(String paymentId) async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    return box.get(paymentId);
  }

  Future<void> deletePaymentRecord(String paymentId) async {
    var box = await Hive.openBox<PaymentHiveModel>(
      HiveTableConstant.paymentBox,
    );
    await box.delete(paymentId);
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.categoryBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.restaurantBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.productBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.cartBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.paymentBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}

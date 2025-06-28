import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/user/data/model/user_hive_model.dart';
import 'package:fooddelivery_b/features/food_category/data/model/category_hive_model.dart';
import 'package:fooddelivery_b/features/restaurant/data/model/restaurant_hive_model.dart';
import 'package:fooddelivery_b/features/food_products/data/model/product_hive_model.dart';
import 'package:fooddelivery_b/features/cart/data/model/cart_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();

    final hiveDbDir = Directory('${directory.path}/mydbb.db');
    if (!await hiveDbDir.exists()) {
      await hiveDbDir.create(recursive: true);
    }

    Hive.init(hiveDbDir.path);

    // Register adapters
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());
    Hive.registerAdapter(RestaurantHiveModelAdapter());
    Hive.registerAdapter(ProductHiveModelAdapter());
    Hive.registerAdapter(CartItemHiveModelAdapter());
    Hive.registerAdapter(CartHiveModelAdapter());
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
        (element) => element.username == username && element.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Category methods
  Future<void> saveCategories(List<CategoryHiveModel> categories) async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.clear(); // Clear existing categories
    for (var category in categories) {
      await box.put(category.categoryId, category);
    }
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    return box.values.toList();
  }

  Future<void> clearCategories() async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.clear();
  }

  Future<void> deleteCategory(String categoryId) async {
    var box = await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryBox);
    await box.delete(categoryId);
  }

  // Restaurant methods
  Future<void> saveRestaurants(List<RestaurantHiveModel> restaurants) async {
    var box = await Hive.openBox<RestaurantHiveModel>(HiveTableConstant.restaurantBox);
    await box.clear();
    for (var restaurant in restaurants) {
      await box.put(restaurant.restaurantId, restaurant);
    }
  }

  Future<List<RestaurantHiveModel>> getAllRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(HiveTableConstant.restaurantBox);
    return box.values.toList();
  }

  Future<void> clearRestaurants() async {
    var box = await Hive.openBox<RestaurantHiveModel>(HiveTableConstant.restaurantBox);
    await box.clear();
  }

  // Product methods
  Future<void> saveProducts(List<ProductHiveModel> products) async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    await box.clear();
    for (var product in products) {
      await box.put(product.productId, product);
    }
  }

  Future<List<ProductHiveModel>> getAllProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    return box.values.toList();
  }

  Future<void> clearProducts() async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
    await box.clear();
  }

  Future<void> deleteProduct(String productId) async {
    var box = await Hive.openBox<ProductHiveModel>(HiveTableConstant.productBox);
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

  Future<void> updateCartItem(String cartItemId, CartItemHiveModel updatedCartItem) async {
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

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.categoryBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.restaurantBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.productBox);
    await Hive.deleteBoxFromDisk(HiveTableConstant.cartBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
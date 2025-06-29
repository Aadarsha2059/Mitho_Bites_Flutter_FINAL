import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/cart/data/model/cart_hive_model.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/data/data_source/cart_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartLocalDatasource implements ICartDataSource {
  final HiveService _hiveService;

  CartLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<void> clearCart() async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear cart: $e");
    }
  }

  @override
  Future<CartEntity> getCart() async {
    try {
      print('🏪 CartLocalDatasource: Getting cart from Hive...');
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      final cartItems = box.values.map((model) => model.toEntity()).toList();
      print('📦 CartLocalDatasource: Found ${cartItems.length} items in Hive');
      print('🔑 CartLocalDatasource: Hive box keys: ${box.keys.toList()}');
      return CartEntity(
        cartId: null,
        userId: null,
        items: cartItems,
        createdAt: null,
        updatedAt: null,
      );
    } catch (e) {
      print('❌ CartLocalDatasource: Error getting cart - $e');
      throw Exception("Failed to get cart: $e");
    }
  }

  @override
  Future<void> saveCart(CartEntity cart) async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      await box.clear();
      for (var cartItem in cart.items) {
        final hiveModel = CartItemHiveModel.fromEntity(cartItem);
        await box.put(hiveModel.cartItemId, hiveModel);
      }
    } catch (e) {
      throw Exception("Failed to save cart: $e");
    }
  }

  @override
  Future<void> addToCart(CartItemEntity cartItem) async {
    try {
      print('➕ CartLocalDatasource: Adding item to Hive - ${cartItem.productName}');
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      final hiveModel = CartItemHiveModel.fromEntity(cartItem);
      await box.put(hiveModel.cartItemId, hiveModel);
      print('✅ CartLocalDatasource: Item saved to Hive with key: ${hiveModel.cartItemId}');
      print('📊 CartLocalDatasource: Total items in Hive after save: ${box.length}');
    } catch (e) {
      print('❌ CartLocalDatasource: Error adding to cart - $e');
      throw Exception("Failed to add to cart: $e");
    }
  }

  @override
  Future<void> updateCartItem(String cartItemId, int quantity) async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      final existingItem = box.get(cartItemId);
      if (existingItem != null) {
        final updatedItem = CartItemHiveModel(
          cartItemId: existingItem.cartItemId,
          productId: existingItem.productId,
          productName: existingItem.productName,
          productType: existingItem.productType,
          productPrice: existingItem.productPrice,
          productDescription: existingItem.productDescription,
          productImage: existingItem.productImage,
          categoryId: existingItem.categoryId,
          restaurantId: existingItem.restaurantId,
          isAvailable: existingItem.isAvailable,
          categoryName: existingItem.categoryName,
          categoryImage: existingItem.categoryImage,
          restaurantName: existingItem.restaurantName,
          restaurantImage: existingItem.restaurantImage,
          restaurantLocation: existingItem.restaurantLocation,
          restaurantContact: existingItem.restaurantContact,
          quantity: quantity,
          price: existingItem.productPrice * quantity,
          createdAt: existingItem.createdAt,
          updatedAt: DateTime.now(),
        );
        await box.put(cartItemId, updatedItem);
      }
    } catch (e) {
      throw Exception("Failed to update cart item: $e");
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      await box.delete(cartItemId);
    } catch (e) {
      throw Exception("Failed to remove from cart: $e");
    }
  }

  @override
  Future<CartItemEntity?> getCartItem(String cartItemId) async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      final hiveModel = box.get(cartItemId);
      return hiveModel?.toEntity();
    } catch (e) {
      throw Exception("Failed to get cart item: $e");
    }
  }

  @override
  Future<List<CartItemEntity>> getAllCartItems() async {
    try {
      var box = await Hive.openBox<CartItemHiveModel>(
        HiveTableConstant.cartBox,
      );
      return box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to get all cart items: $e");
    }
  }
}
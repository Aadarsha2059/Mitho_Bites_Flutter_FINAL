
import 'package:dio/dio.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
import 'package:fooddelivery_b/core/network/api_service.dart';
import 'package:fooddelivery_b/features/cart/data/data_source/cart_datasource.dart';
import 'package:fooddelivery_b/features/cart/data/model/cart_api_model.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

class CartRemoteDatasource implements ICartDataSource {
  final ApiService _apiService;

  CartRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<void> clearCart() async {
    try {
      final response = await _apiService.dio.delete(ApiEndpoints.clearCart);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] != true) {
          throw Exception('Failed to clear cart: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to clear cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to clear cart: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Future<CartEntity> getCart() async {
    try {
      print('🌐 CartRemoteDatasource: Making GET request to ${ApiEndpoints.getCart}');
      final response = await _apiService.dio.get(ApiEndpoints.getCart);

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('✅ CartRemoteDatasource: Got 200 response from backend');
        print('📦 CartRemoteDatasource: Response data keys: ${responseData.keys.toList()}');
        
        if (responseData['success'] == true && responseData['data'] != null) {
          print('📋 CartRemoteDatasource: Parsing cart data...');
          final cartEntity = CartApiModel.fromJson(responseData['data']).toEntity();
          print('✅ CartRemoteDatasource: Successfully parsed cart with ${cartEntity.items.length} items');
          return cartEntity;
        } else {
          print('📭 CartRemoteDatasource: No cart data, returning empty cart');
          // Return empty cart if no data
          return CartEntity(
            cartId: null,
            userId: null,
            items: [],
            createdAt: null,
            updatedAt: null,
          );
        }
      } else {
        print('❌ CartRemoteDatasource: Non-200 response: ${response.statusCode}');
        throw Exception('Failed to get cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('❌ CartRemoteDatasource: DioException - ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      // For Flutter, return empty cart on error (use local storage)
      return CartEntity(
        cartId: null,
        userId: null,
        items: [],
        createdAt: null,
        updatedAt: null,
      );
    } catch (e) {
      print('❌ CartRemoteDatasource: General Exception - $e');
      return CartEntity(
        cartId: null,
        userId: null,
        items: [],
        createdAt: null,
        updatedAt: null,
      );
    }
  }

  @override
  Future<void> saveCart(CartEntity cart) async {
    try {
      final cartApiModel = CartApiModel.fromEntity(cart);
      final response = await _apiService.dio.post(
        ApiEndpoints.getCart, // Using getCart endpoint for saving
        data: cartApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] != true) {
          throw Exception('Failed to save cart: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to save cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to save cart: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to save cart: $e');
    }
  }

  @override
  Future<void> addToCart(CartItemEntity cartItem) async {
    try {
      print('🌐 CartRemoteDatasource: Adding item to cart - ${cartItem.productName}');
      print('📋 CartRemoteDatasource: Request data - productId: ${cartItem.productId}, quantity: ${cartItem.quantity}');
      
      final response = await _apiService.dio.post(
        ApiEndpoints.addToCart,
        data: {
          'productId': cartItem.productId,
          'quantity': cartItem.quantity,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('✅ CartRemoteDatasource: Successfully added item to backend cart');
        if (responseData['success'] != true) {
          print('⚠️ CartRemoteDatasource: Backend returned success=false: ${responseData['message']}');
          throw Exception('Failed to add to cart: ${responseData['message']}');
        }
      } else {
        print('❌ CartRemoteDatasource: Non-200 response: ${response.statusCode}');
        throw Exception('Failed to add to cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('❌ CartRemoteDatasource: DioException - ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      // For Flutter, we can still add to local cart even if server fails
      print('Server validation failed, using local cart: ${e.message}');
    } catch (e) {
      print('❌ CartRemoteDatasource: General error, using local cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(String cartItemId, int quantity) async {
    try {
      final response = await _apiService.dio.put(
        ApiEndpoints.updateCartItem,
        data: {
          'productId': cartItemId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] != true) {
          throw Exception('Failed to update cart item: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to update cart item: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to update cart item: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.removeFromCart}/$cartItemId',
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] != true) {
          throw Exception('Failed to remove from cart: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to remove from cart: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      }
      throw Exception('Failed to remove from cart: ${e.message}');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to remove from cart: $e');
    }
  }

  @override
  Future<CartItemEntity?> getCartItem(String cartItemId) async {
    try {
      // Since there's no specific getCartItem endpoint, we'll get the full cart
      final cart = await getCart();
      try {
        return cart.items.firstWhere(
          (item) => item.cartItemId == cartItemId,
        );
      } catch (e) {
        // Item not found, return null
        return null;
      }
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get cart item: $e');
    }
  }

  @override
  Future<List<CartItemEntity>> getAllCartItems() async {
    try {
      final cart = await getCart();
      return cart.items;
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Failed to get all cart items: $e');
    }
  }
}
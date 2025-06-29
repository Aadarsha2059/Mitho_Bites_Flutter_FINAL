import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

class CartViewModel extends Bloc<CartEvent, CartState> {
  final ICartRepository repository;

  CartViewModel({required this.repository}) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    print('🛒 CartViewModel: Loading cart...');
    emit(const CartLoading());
    
    final result = await repository.getCart();
    result.fold(
      (failure) {
        print('❌ CartViewModel: Failed to load cart - ${failure.message}');
        emit(CartError(failure.message ?? 'Failed to load cart'));
      },
      (cart) {
        print('✅ CartViewModel: Loaded cart with ${cart.items.length} items');
        print('📦 Cart items: ${cart.items.map((item) => '${item.productName} (qty: ${item.quantity})').toList()}');
        emit(CartLoaded(cart.items));
      },
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    print('➕ CartViewModel: Adding item to cart - ${event.cartItem.productName}');
    emit(const CartLoading());
    
    final result = await repository.addToCart(event.cartItem);
    result.fold(
      (failure) {
        print('❌ CartViewModel: Failed to add item to cart - ${failure.message}');
        emit(CartError(failure.message ?? 'Failed to add item to cart'));
      },
      (_) {
        print('✅ CartViewModel: Item added successfully, reloading cart...');
        // Reload cart after adding item
        add(LoadCart());
      },
    );
  }

  Future<void> _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    
    final result = await repository.updateCartItem(event.cartItemId, event.quantity);
    result.fold(
      (failure) {
        emit(CartError(failure.message ?? 'Failed to update cart item'));
      },
      (_) {
        // Reload cart after updating item
        add(LoadCart());
      },
    );
  }

  Future<void> _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    // Optimistic update for instant UI feedback
    if (state is CartLoaded) {
      final currentItems = List<CartItemEntity>.from((state as CartLoaded).cartItems);
      final index = currentItems.indexWhere((item) => item.productId == event.productId);
      if (index != -1 && currentItems[index] != null) {
        final oldItem = currentItems[index]!;
        final updatedItem = oldItem.copyWith(quantity: event.quantity);
        if (updatedItem != null) {
          // Create a new list for Bloc state
          final newItems = List<CartItemEntity>.from(currentItems);
          newItems[index] = updatedItem;
          emit(CartLoaded(newItems));

          final result = await repository.updateCartItem(event.productId, event.quantity);
          result.fold(
            (failure) {
              // Revert change and reload cart for consistency
              final revertedItems = List<CartItemEntity>.from(currentItems);
              revertedItems[index] = oldItem;
              emit(CartLoaded(revertedItems));
              // Optionally: show error in UI via BlocListener
            },
            (_) {
              // Optionally reload from backend for consistency
              add(LoadCart());
            },
          );
          return;
        }
      }
    }
    // Fallback to old behavior
    emit(const CartLoading());
    final result = await repository.updateCartItem(event.productId, event.quantity);
    result.fold(
      (failure) {
        emit(CartError(failure.message ?? 'Failed to update cart item quantity'));
      },
      (_) {
        add(LoadCart());
      },
    );
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    
    final result = await repository.removeFromCart(event.productId);
    result.fold(
      (failure) {
        emit(CartError(failure.message ?? 'Failed to remove item from cart'));
      },
      (_) {
        // Reload cart after removing item
        add(LoadCart());
      },
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    
    final result = await repository.clearCart();
    result.fold(
      (failure) {
        emit(CartError(failure.message ?? 'Failed to clear cart'));
      },
      (_) {
        // Reload cart after clearing
        add(LoadCart());
      },
    );
  }
} 
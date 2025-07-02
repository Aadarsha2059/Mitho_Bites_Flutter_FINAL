import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/payment/presentation/view/payment_view.dart' show PaymentView;
import 'package:fooddelivery_b/features/payment/presentation/view_model/payment_view_model.dart';
import 'package:fooddelivery_b/features/payment/presentation/state/payment_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    serviceLocator<CartViewModel>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<CartViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Shopping Cart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 2,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadCart,
              tooltip: 'Refresh Cart',
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<CartViewModel, CartState>(
            builder: (context, state) {
              return _buildBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CartState state) {
    print('🖥️ CartView: Building body with state: ${state.runtimeType}');
    
    if (state is CartLoading) {
      print('⏳ CartView: Showing loading state');
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CartError) {
      print('❌ CartView: Showing error state - ${state.message}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is CartLoaded) {
      final cartItems = state.cartItems;
      print('📦 CartView: Cart loaded with ${cartItems.length} items');
      print('🛍️ CartView: Items: ${cartItems.map((item) => '${item.productName} (qty: ${item.quantity})').toList()}');
      
      if (cartItems.isEmpty) {
        print('🈳 CartView: Cart is empty, showing empty state');
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      final totalAmount = cartItems.fold<double>(
        0, 
        (sum, item) => sum + (item.price * item.quantity)
      );

      return Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return _buildCartItemCard(cartItem, state);
              },
            ),
          ),
          
          // Order Summary - Fixed at bottom
          _buildOrderSummary(cartItems, totalAmount),
        ],
      );
    }

    // Default state
    return const Center(
      child: Text('No cart data available'),
    );
  }

  Widget _buildCartItemCard(CartItemEntity cartItem, CartState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: cartItem.productImage != null && cartItem.productImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: cartItem.productImage!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                          size: 28,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.productName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${cartItem.price.toStringAsFixed(2)} each',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      // Decrease Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: cartItem.quantity > 1
                              ? () => serviceLocator<CartViewModel>().add(
                                  UpdateCartItemQuantity(
                                    productId: cartItem.productId,
                                    quantity: cartItem.quantity - 1,
                                  ),
                                )
                              : null,
                          icon: Icon(
                            Icons.remove,
                            size: 16,
                            color: cartItem.quantity > 1 ? Colors.black87 : Colors.grey,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ),
                      
                      // Quantity Display
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      
                      // Increase Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => serviceLocator<CartViewModel>().add(
                            UpdateCartItemQuantity(
                              productId: cartItem.productId,
                              quantity: cartItem.quantity + 1,
                            ),
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Remove Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () => serviceLocator<CartViewModel>().add(
                            RemoveFromCart(productId: cartItem.productId),
                          ),
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[600],
                            size: 16,
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Total Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(List<CartItemEntity> cartItems, double totalAmount) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 
        20, 
        20, 
        20 + MediaQuery.of(context).padding.bottom, // Add safe area padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          // Order Summary Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Reduced from 20
          
          // Order Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Reduced from 12
                
                // Delivery Fee
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fee',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Reduced from 16
                
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 12), // Reduced from 16
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Reduced from 24
          
          // Proceed to Payment Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: cartItems.isEmpty 
                ? null 
                : () => _navigateToPayment(context, cartItems, totalAmount),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: Colors.orange.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12), // Reduced from 16
          
          // Security Note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Secure payment powered by MithoBites',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToPayment(BuildContext context, List<CartItemEntity> cartItems, double totalAmount) {
    print('DEBUG: _navigateToPayment called');
    print('DEBUG: Cart items count: ${cartItems.length}');
    print('DEBUG: Total amount: $totalAmount');
    print('DEBUG: Cart items: ${cartItems.map((item) => '${item.productName} (Qty: ${item.quantity})').join(', ')}');

    if (cartItems.isEmpty) {
      print('DEBUG: Cart is empty, cannot navigate to payment');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty. Please add items first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Convert CartItemEntity to CartItem for payment view
      final paymentCartItems = cartItems.map((entity) => CartItem(
        productId: entity.productId,
        productName: entity.productName,
        price: entity.price,
        quantity: entity.quantity,
        image: entity.productImage,
      )).toList();

      print('DEBUG: Converted ${paymentCartItems.length} cart items for payment');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('DEBUG: Building PaymentView');
            return BlocProvider(
              create: (context) {
                print('DEBUG: Creating PaymentViewModel');
                final viewModel = serviceLocator<PaymentViewModel>();
                print('DEBUG: PaymentViewModel created successfully');
                return viewModel;
              },
              child: PaymentView(
                cartItems: paymentCartItems,
                totalAmount: totalAmount,
                onClose: () {
                  print('DEBUG: PaymentView onClose called');
                  Navigator.pop(context);
                },
                onContinueShopping: () {
                  print('DEBUG: PaymentView onContinueShopping called');
                  // Clear cart after successful order
                  serviceLocator<CartViewModel>().add(ClearCart());
                  
                  // Navigate back to home screen
                  Navigator.popUntil(context, (route) => route.isFirst);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
      
      print('DEBUG: Payment navigation completed');
    } catch (e) {
      print('DEBUG: Error navigating to payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error navigating to payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 
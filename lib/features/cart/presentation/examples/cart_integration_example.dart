import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';
import 'package:fooddelivery_b/features/cart/presentation/widgets/cart_icon.dart';

import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/miscellaneous/widgets/product_card.dart';

// Example of how to integrate cart functionality with existing ProductCard
class CartIntegrationExample extends StatelessWidget {
  final ProductsEntity product;

  const CartIntegrationExample({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      product: {
        'productId': product.productId,
        'name': product.name,
        'type': product.type,
        'price': product.price,
        'description': product.description,
        'image': product.image,
        'isAvailable': product.isAvailable,
        'restaurantId': product.restaurantId,
        'restaurantName': product.restaurantName,
        'restaurantImage': product.restaurantImage,
        'categoryId': product.categoryId,
        'categoryName': product.categoryName,
      },
      onAddToCart: () {
        // Create cart item from product
        final cartItem = CartItemEntity(
          cartItemId: null, // Will be generated by backend
          productId: product.productId ?? '', // Handle nullable productId
          productName: product.name,
          productType: 'food',
          productPrice: product.price,
          productDescription: product.description ?? '',
          productImage: product.image,
          categoryId: product.categoryId,
          restaurantId: product.restaurantId,
          isAvailable: product.isAvailable ?? true,
          categoryName: product.categoryName,
          categoryImage: product.categoryImage,
          restaurantName: product.restaurantName,
          restaurantImage: product.restaurantImage,
          restaurantLocation: product.restaurantLocation,
          restaurantContact: product.restaurantContact,
          quantity: 1,
          price: product.price,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Add to cart using the cart view model
        context.read<CartViewModel>().onEvent(AddToCart(cartItem));

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

// Example of how to use CartIcon in AppBar
class ExampleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExampleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Food Delivery'),
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      actions: const [
        // Add cart icon to app bar
        CartIcon(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Example of how to wrap your app with CartProvider
class ExampleAppWithCart extends StatelessWidget {
  final Widget child;
  final ICartRepository cartRepository;

  const ExampleAppWithCart({
    super.key,
    required this.child,
    required this.cartRepository,
  });

  @override
  Widget build(BuildContext context) {
    return child; // No longer need CartProvider since we use singleton
  }
} 
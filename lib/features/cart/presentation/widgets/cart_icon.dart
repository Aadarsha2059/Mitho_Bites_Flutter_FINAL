import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/cart/presentation/view/cart_view.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        final state = cartViewModel.state;
        int itemCount = 0;

        if (state is CartLoaded) {
          itemCount = state.cart.itemCount;
        }

        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartView(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Shopping Cart',
            ),
            if (itemCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
} 
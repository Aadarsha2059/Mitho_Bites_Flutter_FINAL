import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class CartProvider extends StatelessWidget {
  final Widget child;
  final ICartRepository cartRepository;

  const CartProvider({
    Key? key,
    required this.child,
    required this.cartRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartViewModel(repository: cartRepository),
      child: child,
    );
  }
} 
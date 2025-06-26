import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/presentation/state/product_state.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_event.dart';
import 'package:fooddelivery_b/widgets/product_card.dart';

import 'product_viewmodel.dart';

class ProductListView extends StatelessWidget {
  final ProductViewModel viewModel;
  final String categoryId;

  const ProductListView({
    Key? key,
    required this.viewModel,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger loading when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.onEvent(LoadProductsByCategory(categoryId));
    });

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No products found in this category.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              
              // Debug: Print product data
              print('Product $index: ${product.name}');
              print('Product image: ${product.image}');
              print('Restaurant name: ${product.restaurantName}');
              print('Restaurant image: ${product.restaurantImage}');
              
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
                  // TODO: Implement add to cart logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart!')),
                  );
                },
              );
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
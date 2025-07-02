import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/food_products/domain/repository/products_repository.dart';
import 'package:fooddelivery_b/features/food_products/presentation/state/product_state.dart';
import 'product_event.dart';


class ProductViewModel extends ChangeNotifier {
  final IProductRepository repository;
  ProductState _state = ProductInitial();
  ProductState get state => _state;

  ProductViewModel({required this.repository});

  Future<void> onEvent(ProductEvent event) async {
    if (event is LoadProductsByCategory) {
      _state = ProductLoading();
      notifyListeners();
      final result = await repository.getProductsByCategory(event.categoryId);
      result.fold(
        (failure) {
          _state = ProductError(failure.message ?? 'Failed to load products');
          notifyListeners();
        },
        (products) {
          _state = ProductLoaded(products);
          notifyListeners();
        },
      );
    } else if (event is RefreshProducts) {
      // Optionally handle refresh logic
      await onEvent(LoadProductsByCategory(event.categoryId));
    }
  }
}
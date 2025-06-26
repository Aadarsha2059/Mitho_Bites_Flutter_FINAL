abstract class ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final String categoryId;
  LoadProductsByCategory(this.categoryId);
}

class RefreshProducts extends ProductEvent {
  final String categoryId;
  RefreshProducts(this.categoryId);
}
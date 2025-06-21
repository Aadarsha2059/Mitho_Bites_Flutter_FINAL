import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

class CategoryState extends Equatable {
  final List<FoodCategoryEntity> categories;
  final bool isLoading;
  final String? errorMessage;

  const CategoryState({
    required this.categories,
    required this.isLoading,
    this.errorMessage,
  });

  const CategoryState.initial()
    : categories = const [],
      isLoading = false,
      errorMessage = null;

  CategoryState copyWith({
    List<FoodCategoryEntity>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, errorMessage];
} 
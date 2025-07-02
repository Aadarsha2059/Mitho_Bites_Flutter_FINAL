import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

class MenuState extends Equatable {
  final List<FoodCategoryEntity> categories;
  final List<FoodCategoryEntity> filteredCategories;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedCategoryId;

  const MenuState({
    required this.categories,
    required this.filteredCategories,
    required this.isLoading,
    this.errorMessage,
    required this.searchQuery,
    this.selectedCategoryId,
  });

  const MenuState.initial()
      : categories = const [],
        filteredCategories = const [],
        isLoading = false,
        errorMessage = null,
        searchQuery = '',
        selectedCategoryId = null;

  MenuState copyWith({
    List<FoodCategoryEntity>? categories,
    List<FoodCategoryEntity>? filteredCategories,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategoryId,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        filteredCategories,
        isLoading,
        errorMessage,
        searchQuery,
        selectedCategoryId,
      ];
} 
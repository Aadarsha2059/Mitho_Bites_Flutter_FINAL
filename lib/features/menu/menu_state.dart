import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

class MenuState extends Equatable {
  final List<FoodCategoryEntity> categories;
  final List<FoodCategoryEntity> filteredCategories;
  final List<String> restaurants;
  final List<String> filteredRestaurants;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedCategoryId;
  final String searchStatus;

  const MenuState({
    required this.categories,
    required this.filteredCategories,
    required this.restaurants,
    required this.filteredRestaurants,
    required this.isLoading,
    this.errorMessage,
    required this.searchQuery,
    this.selectedCategoryId,
    required this.searchStatus,
  });

  const MenuState.initial()
      : categories = const [],
        filteredCategories = const [],
        restaurants = const [
          'Koteshwor Rooftop',
          'Dillibazar Delicious',
          'Kapan Crunch Restro',
        ],
        filteredRestaurants = const [
          'Koteshwor Rooftop',
          'Dillibazar Delicious',
          'Kapan Crunch Restro',
        ],
        isLoading = false,
        errorMessage = null,
        searchQuery = '',
        selectedCategoryId = null,
        searchStatus = '';

  MenuState copyWith({
    List<FoodCategoryEntity>? categories,
    List<FoodCategoryEntity>? filteredCategories,
    List<String>? restaurants,
    List<String>? filteredRestaurants,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategoryId,
    String? searchStatus,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchStatus: searchStatus ?? this.searchStatus,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        filteredCategories,
        restaurants,
        filteredRestaurants,
        isLoading,
        errorMessage,
        searchQuery,
        selectedCategoryId,
        searchStatus,
      ];
} 
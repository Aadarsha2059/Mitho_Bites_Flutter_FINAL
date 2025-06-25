import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/menu/menu_event.dart';
import 'package:fooddelivery_b/features/menu/menu_state.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';

class MenuViewModel extends Bloc<MenuEvent, MenuState> {
  final GetCategoriesUsecase getCategoriesUsecase;

  MenuViewModel({required this.getCategoriesUsecase}) : super(MenuState.initial()) {
    on<LoadMenuCategoriesEvent>(_onLoadMenuCategories);
    on<SearchCategoriesEvent>(_onSearchCategories);
    on<SelectCategoryEvent>(_onSelectCategory);
    add(const LoadMenuCategoriesEvent());
  }

  Future<void> _onLoadMenuCategories(
    LoadMenuCategoriesEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getCategoriesUsecase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (categories) {
        emit(state.copyWith(
          categories: categories,
          filteredCategories: categories,
          isLoading: false,
        ));
      },
    );
  }

  void _onSearchCategories(
    SearchCategoriesEvent event,
    Emitter<MenuState> emit,
  ) {
    final searchQuery = event.searchQuery.toLowerCase();
    List<FoodCategoryEntity> filteredCategories;

    if (searchQuery.isEmpty) {
      filteredCategories = state.categories;
    } else {
      filteredCategories = state.categories
          .where((category) =>
              category.name.toLowerCase().contains(searchQuery))
          .toList();
    }

    emit(state.copyWith(
      filteredCategories: filteredCategories,
      searchQuery: searchQuery,
    ));
  }

  void _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<MenuState> emit,
  ) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
  }
} 
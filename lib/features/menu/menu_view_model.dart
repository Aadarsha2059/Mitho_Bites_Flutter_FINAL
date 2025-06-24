import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/menu/menu_event.dart';
import 'package:fooddelivery_b/features/menu/menu_state.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';

class MenuViewModel extends Bloc<MenuEvent, MenuState> {
  final GetCategoriesUsecase getCategoriesUsecase;

  MenuViewModel({required this.getCategoriesUsecase}) : super(const MenuState.initial()) {
    on<LoadMenuCategoriesEvent>(_onLoadMenuCategories);
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
        emit(state.copyWith(categories: categories, isLoading: false));
      },
    );
  }
} 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_event.dart';
import 'package:fooddelivery_b/features/food_category/presentation/state/category_state.dart';

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUsecase getCategoriesUsecase;

  CategoryViewModel({
    required this.getCategoriesUsecase,
  }) : super(const CategoryState.initial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadSampleCategoriesEvent>(_onLoadSampleCategories);


    add(const LoadCategoriesEvent());
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CategoryState> emit,
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

  Future<void> _onLoadSampleCategories(
    LoadSampleCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    
    final sampleCategories = [
      const FoodCategoryEntity(
        categoryId: '1',
        name: 'Burger',
        image: 'assets/images/cat_offer.png',
      ),
      const FoodCategoryEntity(
        categoryId: '2',
        name: 'Dal-Bhat',
        image: 'assets/images/cat_sri.png',
      ),
      const FoodCategoryEntity(
        categoryId: '3',
        name: 'Chinese',
        image: 'assets/images/cat_3.png',
      ),
      const FoodCategoryEntity(
        categoryId: '4',
        name: 'Indian',
        image: 'assets/images/cat_4.png',
      ),
    ];
    
    emit(state.copyWith(
      categories: sampleCategories,
      isLoading: false,
    ));
  }
} 
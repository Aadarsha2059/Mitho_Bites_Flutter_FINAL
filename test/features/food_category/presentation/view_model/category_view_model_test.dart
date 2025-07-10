import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_event.dart';
import 'package:fooddelivery_b/features/food_category/presentation/state/category_state.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';

class MockGetCategoriesUsecase extends Mock implements GetCategoriesUsecase {}

void main() {
  late GetCategoriesUsecase getCategoriesUsecase;
  // late CategoryViewModel categoryViewModel; // REMOVE THIS LINE

  setUp(() {
    getCategoriesUsecase = MockGetCategoriesUsecase();
    when(() => getCategoriesUsecase()).thenAnswer((_) async => const Right(<FoodCategoryEntity>[]));
    // categoryViewModel = CategoryViewModel(getCategoriesUsecase: getCategoriesUsecase); // REMOVE THIS LINE
  });

  group('CategoryViewModel', () {
    final category1 = const FoodCategoryEntity(categoryId: '1', name: 'Burger', image: 'assets/images/cat_offer.png');
    final category2 = const FoodCategoryEntity(categoryId: '2', name: 'Dal-Bhat', image: 'assets/images/cat_sri.png');
    final categories = [category1, category2];

    blocTest<CategoryViewModel, CategoryState>(
      'emits [loading, loaded] when LoadCategoriesEvent succeeds',
      build: () {
        when(() => getCategoriesUsecase()).thenAnswer((_) async => Right(categories));
        return CategoryViewModel(getCategoriesUsecase: getCategoriesUsecase);
      },
      act: (bloc) => bloc.add(const LoadCategoriesEvent()),
      skip: 2,
      expect: () => [
        CategoryState.initial().copyWith(isLoading: true),
        CategoryState.initial().copyWith(categories: categories, isLoading: false),
      ],
      verify: (_) {
        verify(() => getCategoriesUsecase()).called(2);
      },
    );

    blocTest<CategoryViewModel, CategoryState>(
      'emits [loading, error] when LoadCategoriesEvent fails',
      build: () {
        when(() => getCategoriesUsecase()).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Error')));
        return CategoryViewModel(getCategoriesUsecase: getCategoriesUsecase);
      },
      act: (bloc) => bloc.add(const LoadCategoriesEvent()),
      skip: 2,
      expect: () => [
        CategoryState.initial().copyWith(isLoading: true, errorMessage: 'Error'),
        CategoryState.initial().copyWith(isLoading: false, errorMessage: 'Error'),
      ],
      verify: (_) {
        verify(() => getCategoriesUsecase()).called(2);
      },
    );

    blocTest<CategoryViewModel, CategoryState>(
      'emits [loading, loaded] with sample categories when LoadSampleCategoriesEvent is added',
      build: () {
        return CategoryViewModel(getCategoriesUsecase: getCategoriesUsecase);
      },
      act: (bloc) => bloc.add(const LoadSampleCategoriesEvent()),
      skip: 2,
      wait: const Duration(milliseconds: 600),
      expect: () => [
        CategoryState.initial().copyWith(isLoading: true),
        CategoryState.initial().copyWith(
          categories: const [
            FoodCategoryEntity(categoryId: '1', name: 'Burger', image: 'assets/images/cat_offer.png'),
            FoodCategoryEntity(categoryId: '2', name: 'Dal-Bhat', image: 'assets/images/cat_sri.png'),
            FoodCategoryEntity(categoryId: '3', name: 'Chinese', image: 'assets/images/cat_3.png'),
            FoodCategoryEntity(categoryId: '4', name: 'Indian', image: 'assets/images/cat_4.png'),
          ],
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(() => getCategoriesUsecase()).called(1);
      },
    );

    blocTest<CategoryViewModel, CategoryState>(
      'emits [loading, loaded (empty)] when LoadCategoriesEvent returns empty list',
      build: () {
        when(() => getCategoriesUsecase()).thenAnswer((_) async => const Right(<FoodCategoryEntity>[]));
        return CategoryViewModel(getCategoriesUsecase: getCategoriesUsecase);
      },
      act: (bloc) => bloc.add(const LoadCategoriesEvent()),
      skip: 2,
      expect: () => [
        CategoryState.initial().copyWith(isLoading: true),
        CategoryState.initial().copyWith(categories: const [], isLoading: false),
      ],
      verify: (_) {
        verify(() => getCategoriesUsecase()).called(2);
      },
    );
  });

  tearDown(() {
    // No need to close a global instance, bloc is created in each test
  });
}
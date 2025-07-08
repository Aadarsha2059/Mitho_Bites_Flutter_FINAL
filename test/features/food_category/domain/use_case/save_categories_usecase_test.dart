import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/save_categories_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockCategoryRepository mockRepository;
  late SaveCategoriesUsecase usecase;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = SaveCategoriesUsecase(categoryRepository: mockRepository);
  });

  final tCategories = [
    FoodCategoryEntity(name: 'Burger', image: 'burger.png'),
    FoodCategoryEntity(name: 'Pizza', image: 'pizza.png'),
  ];

  test('should save categories successfully', () async {
    when(() => mockRepository.saveCategories(tCategories))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tCategories);

    expect(result, const Right(null));
    verify(() => mockRepository.saveCategories(tCategories)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.saveCategories(tCategories))
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase(tCategories);

    expect(result, isA<Left<Failure, void>>());
    verify(() => mockRepository.saveCategories(tCategories)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
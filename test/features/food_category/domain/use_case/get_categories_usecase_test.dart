import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/get_categories_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockCategoryRepository mockRepository;
  late GetCategoriesUsecase usecase;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetCategoriesUsecase(categoryRepository: mockRepository);
  });

  final tCategories = [
    FoodCategoryEntity(name: 'Burger', image: 'burger.png'),
    FoodCategoryEntity(name: 'Pizza', image: 'pizza.png'),
  ];

  test('should return list of categories on success', () async {
    when(() => mockRepository.getCategories())
        .thenAnswer((_) async => Right(tCategories));

    final result = await usecase();

    expect(result, Right(tCategories));
    verify(() => mockRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.getCategories())
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase();

    expect(result, isA<Left<Failure, List<FoodCategoryEntity>>>());
    verify(() => mockRepository.getCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
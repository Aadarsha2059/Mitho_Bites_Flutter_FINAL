import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/food_category/domain/use_case/clear_categories_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockCategoryRepository mockRepository;
  late ClearCategoriesUsecase usecase;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = ClearCategoriesUsecase(categoryRepository: mockRepository);
  });

  test('should clear categories successfully', () async {
    when(() => mockRepository.clearCategories())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase();

    expect(result, const Right(null));
    verify(() => mockRepository.clearCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.clearCategories())
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase();

    expect(result, isA<Left<Failure, void>>());
    verify(() => mockRepository.clearCategories()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
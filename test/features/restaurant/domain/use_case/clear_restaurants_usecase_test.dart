import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/clear_restaurants_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockRestaurantRepository mockRepository;
  late ClearRestaurantsUsecase usecase;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = ClearRestaurantsUsecase(restaurantRepository: mockRepository);
  });

  test('should clear restaurants successfully', () async {
    when(() => mockRepository.clearRestaurants())
        .thenAnswer((_) async => const Right(null));

    final result = await usecase();

    expect(result, const Right(null));
    verify(() => mockRepository.clearRestaurants()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.clearRestaurants())
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase();

    expect(result, isA<Left<Failure, void>>());
    verify(() => mockRepository.clearRestaurants()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
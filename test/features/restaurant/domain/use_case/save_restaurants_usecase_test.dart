import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/save_restaurants_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockRestaurantRepository mockRepository;
  late SaveRestaurantsUsecase usecase;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = SaveRestaurantsUsecase(restaurantRepository: mockRepository);
  });

  final tRestaurants = [
    RestaurantEntity(
      restaurantId: '1',
      name: 'testaurant',
      contact: '1234567890',
      location: 'Kathmandu',
      image: 'test.png',
    ),
    RestaurantEntity(
      restaurantId: '2',
      name: 'Food Place',
      contact: '0987654321',
      location: 'Lalitpur',
      image: 'food.png',
    ),
  ];

  test('should save restaurants successfully', () async {
    when(() => mockRepository.saveRestaurants(tRestaurants))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tRestaurants);

    expect(result, const Right(null));
    verify(() => mockRepository.saveRestaurants(tRestaurants)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.saveRestaurants(tRestaurants))
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase(tRestaurants);

    expect(result, isA<Left<Failure, void>>());
    verify(() => mockRepository.saveRestaurants(tRestaurants)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
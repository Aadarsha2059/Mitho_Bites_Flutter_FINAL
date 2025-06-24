import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';

class RestaurantState extends Equatable {
  final List<RestaurantEntity> restaurants;
  final bool isLoading;
  final String? errorMessage;

  const RestaurantState({
    required this.restaurants,
    required this.isLoading,
    this.errorMessage,
  });

  const RestaurantState.initial()
      : restaurants = const [],
        isLoading = false,
        errorMessage = null;

  RestaurantState copyWith({
    List<RestaurantEntity>? restaurants,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [restaurants, isLoading, errorMessage];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/get_restaurants_usecase.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/state/restaurant_state.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_event.dart';

class RestaurantViewModel extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUsecase getRestaurantsUsecase;

  RestaurantViewModel({required this.getRestaurantsUsecase})
      : super(const RestaurantState.initial()) {
    on<LoadRestaurantsEvent>(_onLoadRestaurants);
    add(const LoadRestaurantsEvent());
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getRestaurantsUsecase();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (restaurants) {
        emit(state.copyWith(restaurants: restaurants, isLoading: false));
      },
    );
  }
}

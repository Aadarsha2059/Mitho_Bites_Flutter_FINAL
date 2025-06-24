import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String? restaurantId;
  final String name;
  final String contact;
  final String location;
  final String? image;

  const RestaurantEntity({
    this.restaurantId,
    required this.name,
    required this.contact,
    required this.location,
    required this.image,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    restaurantId,
    name,
    image,
    contact,
    location,
  ];

}

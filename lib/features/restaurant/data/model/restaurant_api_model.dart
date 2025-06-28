import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_api_model.g.dart';

@JsonSerializable()
class RestaurantApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? restaurantId;
  final String name;
  final String contact;
  final String location;
  @JsonKey(name: 'image')
  final String? image;

  const RestaurantApiModel({
    this.restaurantId,
    required this.name,
    required this.contact,
    required this.location,
    this.image,
  });
  
  factory RestaurantApiModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantApiModelToJson(this);

  //to entity - Use image URL directly from backend
  RestaurantEntity toEntity() {
    return RestaurantEntity(
      restaurantId: restaurantId,
      name: name,
      contact: contact,
      location: location,
      image: image, // Backend already provides full URL
    );
  }

  //from entity
  factory RestaurantApiModel.fromEntity(RestaurantEntity entity) {
    return RestaurantApiModel(
      restaurantId: entity.restaurantId,
      name: entity.name,
      contact: entity.contact,
      location: entity.location,
      image: entity.image,
    );
  }

  @override
  List<Object?> get props => [restaurantId, name, image, contact, location];
}

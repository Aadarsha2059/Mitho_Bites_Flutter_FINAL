import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';
part 'restaurant_api_model.g.dart';

@JsonSerializable()
class RestaurantApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? restaurantId;
  final String name;
  final String contact;
  final String location;
  @JsonKey(name: 'filepath')
  final String? filepath;

  const RestaurantApiModel({
    this.restaurantId,
    required this.name,
    required this.contact,
    required this.location,
    this.filepath,
  });
  factory RestaurantApiModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantApiModelToJson(this);

  //to entity
  RestaurantEntity toEntity() {
    String? imageUrl;
    if (filepath != null && filepath!.isNotEmpty) {
      // Avoid double 'uploads/uploads' in the image URL
      if (filepath!.startsWith('uploads/')) {
        imageUrl = '${ApiEndpoints.serverAddress}/$filepath';
      } else {
        imageUrl = '${ApiEndpoints.imageUrl}$filepath';
      }
    }
    return RestaurantEntity(
      restaurantId: restaurantId,
      name: name,
      contact: contact,
      location: location,
      image: imageUrl,
    );
  }

  //from entity
  factory RestaurantApiModel.fromEntity(RestaurantEntity entity) {
    final restaurant = RestaurantApiModel(
      name: entity.name,
      contact: entity.contact,
      location: entity.location,
      filepath: entity.image,
    );
    return restaurant;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [restaurantId, name, filepath, contact, location];
}

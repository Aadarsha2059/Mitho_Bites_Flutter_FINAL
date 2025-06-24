import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'restaurant_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.restaurantTableId)
class RestaurantHiveModel extends Equatable {
  @HiveField(0)
  final String? restaurantId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String contact;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String? image;

  RestaurantHiveModel({
    String? restaurantId,
    required this.name,
    required this.location,
    required this.contact,
    required this.image,
  }) : restaurantId = restaurantId ?? const Uuid().v4();

  //constructor
  const RestaurantHiveModel.initial()
    : restaurantId = '',
      name = '',
      image = '',
      location = '',
      contact = '';

  //from entity
  factory RestaurantHiveModel.fromEntity(RestaurantEntity entity) {
    return RestaurantHiveModel(
      restaurantId: entity.restaurantId,
      name: entity.name,
      location: entity.location,
      contact: entity.contact,
      image: entity.image,
    );
  }
  //to entity
  RestaurantEntity toEntity() {
    return RestaurantEntity(
      restaurantId: restaurantId,
      name: name,
      contact: contact,
      location: location,
      image: image,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    restaurantId,
    name,
    location,
    contact,
    image,
  ];
  
}

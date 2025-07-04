import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: 1)
class CategoryHiveModel extends Equatable {
  @HiveField(0)
  final String? categoryId;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? image;

  CategoryHiveModel({
    String? categoryId,
    required this.name,
    required this.image,
  }) : categoryId = categoryId ?? const Uuid().v4();

  //initial constructor
  const CategoryHiveModel.initial() : categoryId = '', name = '', image = '';

  //from entity
  factory CategoryHiveModel.fromEntity(FoodCategoryEntity entity) {
    return CategoryHiveModel(
      categoryId: entity.categoryId,
      name: entity.name,
      image: entity.image,
    );
  }
  // to entity

  FoodCategoryEntity toEntity() {
    return FoodCategoryEntity(categoryId: categoryId, name: name, image: image);

  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    categoryId,
    name,
    image,
  ];
  
}

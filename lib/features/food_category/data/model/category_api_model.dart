import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String name;
  @JsonKey(name: 'image')
  final String? image;

  const CategoryApiModel({
    this.categoryId,
    required this.name,
    this.image,
  });
  
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // to entity - Use image URL directly from backend
  FoodCategoryEntity toEntity() {
    return FoodCategoryEntity(
      categoryId: categoryId, 
      name: name, 
      image: image // Backend already provides full URL
    );
  }

  //from entity
  factory CategoryApiModel.fromEntity(FoodCategoryEntity entity) {
    return CategoryApiModel(
      categoryId: entity.categoryId,
      name: entity.name, 
      image: entity.image
    );
  }
  
  @override
  List<Object?> get props => [
    categoryId,
    name,
    image,
  ];
}

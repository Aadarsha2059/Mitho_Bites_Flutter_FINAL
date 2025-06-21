import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String name;
  final String? image;

  const CategoryApiModel({
    this.categoryId,
    required this.name,
    required this.image,
  });
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // to entity
  FoodCategoryEntity toEntity() {
    return FoodCategoryEntity(categoryId: categoryId, name: name, image: image);
  }

  //from entity
  factory CategoryApiModel.fromEntity(FoodCategoryEntity entity) {
    final category = CategoryApiModel(name: entity.name, image: entity.image);
    return category;
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    categoryId,
    name,
    image,
  ];
}

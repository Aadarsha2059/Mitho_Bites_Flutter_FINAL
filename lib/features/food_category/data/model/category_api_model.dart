import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String name;
  @JsonKey(name: 'filepath')
  final String? filepath;

  const CategoryApiModel({
    this.categoryId,
    required this.name,
    this.filepath,
  });
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // to entity - Convert filepath to full image URL
  FoodCategoryEntity toEntity() {
    String? imageUrl;
    if (filepath != null && filepath!.isNotEmpty) {
      imageUrl = 'http://10.0.2.2:3000/$filepath';
    }
    return FoodCategoryEntity(categoryId: categoryId, name: name, image: imageUrl);
  }

  //from entity
  factory CategoryApiModel.fromEntity(FoodCategoryEntity entity) {
    final category = CategoryApiModel(name: entity.name, filepath: entity.image);
    return category;
  }
  
  @override
  List<Object?> get props => [
    categoryId,
    name,
    filepath,
  ];
}

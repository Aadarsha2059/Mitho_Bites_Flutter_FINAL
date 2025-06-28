import 'package:equatable/equatable.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? productId;
  final String name;
  final String type;
  final double price;
  final String description;
  @JsonKey(name: 'image')
  final String? image;
  final String? categoryId;
  final String? restaurantId;
  final bool isAvailable;
  final String? categoryName;
  final String? categoryImage;
  final String? restaurantName;
  final String? restaurantImage;
  final String? restaurantLocation;
  final String? restaurantContact;

  const ProductApiModel({
    this.productId,
    required this.name,
    required this.type,
    required this.price,
    required this.description,
    this.image,
    this.categoryId,
    this.restaurantId,
    required this.isAvailable,
    this.categoryName,
    this.categoryImage,
    this.restaurantName,
    this.restaurantImage,
    this.restaurantLocation,
    this.restaurantContact,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) => ProductApiModel(
    productId: json['_id'] as String?,
    name: json['name'] as String,
    type: json['type'] as String,
    price: (json['price'] as num).toDouble(),
    description: json['description'] as String,
    image: json['image'] as String?,
    categoryId: json['categoryId'] as String?,
    restaurantId: json['restaurantId'] as String?,
    isAvailable: json['isAvailable'] as bool,
    categoryName: json['categoryName'] as String?,
    categoryImage: json['categoryImage'] as String?,
    restaurantName: json['restaurantName'] as String?,
    restaurantImage: json['restaurantImage'] as String?,
    restaurantLocation: json['restaurantLocation'] as String?,
    restaurantContact: json['restaurantContact'] as String?,
  );

  Map<String, dynamic> toJson() => {
    '_id': productId,
    'name': name,
    'type': type,
    'price': price,
    'description': description,
    'image': image,
    'categoryId': categoryId,
    'restaurantId': restaurantId,
    'isAvailable': isAvailable,
    'categoryName': categoryName,
    'categoryImage': categoryImage,
    'restaurantName': restaurantName,
    'restaurantImage': restaurantImage,
    'restaurantLocation': restaurantLocation,
    'restaurantContact': restaurantContact,
  };

  // to entity - Use image URL directly from backend
  ProductsEntity toEntity() {
    return ProductsEntity(
      productId: productId,
      name: name,
      type: type,
      price: price,
      description: description,
      image: image, // Backend already provides full URL
      categoryId: categoryId,
      restaurantId: restaurantId,
      isAvailable: isAvailable,
      categoryName: categoryName,
      categoryImage: categoryImage, // Backend already provides full URL
      restaurantName: restaurantName,
      restaurantImage: restaurantImage, // Backend already provides full URL
      restaurantLocation: restaurantLocation,
      restaurantContact: restaurantContact,
    );
  }

  // from entity
  factory ProductApiModel.fromEntity(ProductsEntity entity) {
    return ProductApiModel(
      productId: entity.productId,
      name: entity.name,
      type: entity.type,
      price: entity.price,
      description: entity.description,
      image: entity.image,
      categoryId: entity.categoryId,
      restaurantId: entity.restaurantId,
      isAvailable: entity.isAvailable,
      categoryName: entity.categoryName,
      categoryImage: entity.categoryImage,
      restaurantName: entity.restaurantName,
      restaurantImage: entity.restaurantImage,
      restaurantLocation: entity.restaurantLocation,
      restaurantContact: entity.restaurantContact,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        type,
        price,
        description,
        image,
        categoryId,
        restaurantId,
        isAvailable,
        categoryName,
        categoryImage,
        restaurantName,
        restaurantImage,
        restaurantLocation,
        restaurantContact,
      ];
}
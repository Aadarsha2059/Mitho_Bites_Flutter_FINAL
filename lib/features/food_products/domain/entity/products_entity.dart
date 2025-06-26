import 'package:equatable/equatable.dart';

class ProductsEntity extends Equatable {
  final String? productId;
  final String name;
  final double price;
  final String type;
  final String description;
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

  const ProductsEntity({
    this.productId,
    required this.name,
    required this.price,
    required this.type,
    required this.description,
    required this.image,
    this.restaurantId,
    this.categoryId,
    required this.isAvailable,
    this.categoryName,
    this.categoryImage,
    this.restaurantName,
    this.restaurantImage,
    this.restaurantLocation,
    this.restaurantContact,
  });
  
  @override
  List<Object?> get props => [
    productId,
    name,
    price,
    description,
    type,
    image,
    restaurantId,
    categoryId,
    isAvailable,
    categoryName,
    categoryImage,
    restaurantName,
    restaurantImage,
    restaurantLocation,
    restaurantContact,
  ];
}
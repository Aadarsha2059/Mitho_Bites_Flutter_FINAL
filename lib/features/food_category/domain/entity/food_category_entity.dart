import 'package:equatable/equatable.dart';

class FoodCategoryEntity extends Equatable {
  final String? categoryId;
  final String name;
  final String? image;

  const FoodCategoryEntity({
    this.categoryId,
    required this.name,
    required this.image,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    categoryId,
    name,
    image,
  ];
  
}

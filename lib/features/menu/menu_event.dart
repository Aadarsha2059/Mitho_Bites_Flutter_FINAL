import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuCategoriesEvent extends MenuEvent {
  const LoadMenuCategoriesEvent();
}

class SearchCategoriesEvent extends MenuEvent {
  final String searchQuery;

  const SearchCategoriesEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class SelectCategoryEvent extends MenuEvent {
  final String categoryId;

  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
} 
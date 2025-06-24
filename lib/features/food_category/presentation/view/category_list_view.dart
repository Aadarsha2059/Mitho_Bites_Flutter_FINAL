import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';
import 'package:fooddelivery_b/features/food_category/presentation/state/category_state.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Food Categories'),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
      ),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<CategoryViewModel, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          if (state.categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return GestureDetector(
                  onTap: () {
                    // TODO: Handle category tap (navigate to category details/products)
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: category.image != null && category.image!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: category.image!,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                )
                              : Container(
                                  height: 90,
                                  width: 90,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image, size: 48, color: Colors.grey),
                                ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 
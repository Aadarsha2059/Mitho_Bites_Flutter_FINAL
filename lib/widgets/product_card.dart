import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/cart/presentation/widgets/add_to_cart_icon_button.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  const ProductCard({
    required this.product,
    required this.onAddToCart,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: product['image'] != null && product['image'].toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product['image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading product image: ${product['image']} - $error');
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                                );
                              },
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                // Product Name
                Text(
                  product['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price
                Text(
                  'NPR ${product['price']?.toString() ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 4),
                // Type
                Text(
                  product['type'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blue, fontSize: 14),
                ),
                const SizedBox(height: 8),
                // Restaurant Name with Image
                Row(
                  children: [
                    if (product['restaurantImage'] != null && product['restaurantImage'].toString().isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          product['restaurantImage'],
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 16, color: Colors.deepOrange),
                        ),
                      )
                    else
                      const Icon(Icons.restaurant, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        product['restaurantName'] ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                    label: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: onAddToCart,
                  ),
                ),
              ],
            ),
          ),
          // Cart Icon at top right using AddToCartIconButton
          Positioned(
            top: 8,
            right: 8,
            child: AddToCartIconButton(
              product: ProductsEntity(
                productId: product['productId'] ?? '',
                name: product['name'] ?? '',
                type: product['type'] ?? '',
                price: product['price']?.toDouble() ?? 0.0,
                description: product['description'] ?? '',
                image: product['image'] ?? '',
                isAvailable: product['isAvailable'] ?? true,
                restaurantId: product['restaurantId'] ?? '',
                restaurantName: product['restaurantName'] ?? '',
                restaurantImage: product['restaurantImage'] ?? '',
                categoryId: product['categoryId'] ?? '',
                categoryName: product['categoryName'] ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
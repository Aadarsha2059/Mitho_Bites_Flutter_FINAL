import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_viewmodel.dart';
import 'package:fooddelivery_b/features/menu/menu_view_model.dart';
import 'package:fooddelivery_b/features/menu/menu_state.dart';
import 'package:fooddelivery_b/features/menu/menu_event.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/food_products/presentation/state/product_state.dart';
import 'package:fooddelivery_b/features/food_products/presentation/view_model/product_event.dart';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:fooddelivery_b/features/cart/presentation/view/cart_view.dart';
import 'package:fooddelivery_b/features/user/domain/use_case/user_get_current_usecase.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String? userAddress;
  bool isLoadingAddress = true;

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  Future<void> _fetchUserAddress() async {
    final usecase = serviceLocator<UserGetCurrentUsecase>();
    final result = await usecase();
    setState(() {
      isLoadingAddress = false;
      userAddress = result.fold(
        (failure) => null,
        (user) => user.address.isNotEmpty ? user.address : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<CartViewModel>(),
      child: BlocProvider<MenuViewModel>(
        create: (_) => serviceLocator<MenuViewModel>(),
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F6F2),
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                _buildSearchBar(),
                _buildCategoryChips(),
                Expanded(child: _buildProductGrid()),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingCartIcon(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.location_on, color: Colors.orange, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: isLoadingAddress
                ? const Text('Loading address...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                : Text(
                    userAddress ?? 'Address not set',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.orange, size: 26),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return BlocBuilder<MenuViewModel, MenuState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: TextField(
            onChanged: (value) {
              context.read<MenuViewModel>().add(SearchCategoriesEvent(value));
            },
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChips() {
    return BlocBuilder<MenuViewModel, MenuState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(color: Colors.orange)),
          );
        }
        if (state.filteredCategories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text('No categories available', style: TextStyle(color: Colors.grey))),
          );
        }
        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: state.filteredCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = state.filteredCategories[index];
              final isSelected = category.categoryId == state.selectedCategoryId;
              return ChoiceChip(
                label: Text(category.name, style: TextStyle(
                  color: isSelected ? Colors.white : Colors.brown[700],
                  fontWeight: FontWeight.bold,
                )),
                selected: isSelected,
                selectedColor: Colors.orange,
                backgroundColor: Colors.brown[50],
                onSelected: (_) {
                  context.read<MenuViewModel>().add(SelectCategoryEvent(category.categoryId!));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isSelected ? 4 : 0,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<MenuViewModel, MenuState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }
        if (state.selectedCategoryId == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Select a category to view items',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }
        return ChangeNotifierProvider<ProductViewModel>(
          create: (_) => serviceLocator<ProductViewModel>(),
          child: _ProductGrid(categoryId: state.selectedCategoryId!),
        );
      },
    );
  }

  Widget _buildFloatingCartIcon() {
    return BlocBuilder<CartViewModel, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        if (state is CartLoaded) {
          itemCount = state.cartItems.fold(0, (sum, item) => sum + item.quantity);
          print('🛒 MenuView: Floating cart icon - $itemCount items in cart');
        }

        return FloatingActionButton(
          onPressed: () {
            print('🛒 MenuView: User clicked floating cart icon');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartView()),
            );
          },
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 8,
          child: Stack(
            children: [
              const Icon(Icons.shopping_cart, size: 28),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final String categoryId;
  const _ProductGrid({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.onEvent(LoadProductsByCategory(categoryId));
    });
    
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_food, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No products found in this category.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }
          
          // Calculate responsive grid parameters
          final screenWidth = MediaQuery.of(context).size.width;
          final crossAxisCount = screenWidth > 600 ? 3 : 2;
          final childAspectRatio = screenWidth > 600 ? 0.75 : 0.72;
          
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return _ProductCard(product: product);
            },
          );
        } else if (state is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductsEntity product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[50],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: product.image != null && product.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.fastfood,
                            size: 40,
                            color: Colors.orange,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.fastfood,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
              ),
            ),
          ),
          
          // Product Details Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Restaurant Info
                  if (product.restaurantName != null && product.restaurantName!.isNotEmpty)
                    Text(
                      product.restaurantName!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const Spacer(),
                  
                  // Price and Add to Cart Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                      
                      // Add to Cart Button
                      _AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final ProductsEntity product;
  const _AddToCartButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartViewModel, CartState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _addToCart(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context) async {
    try {
      print('➕ MenuView: Adding ${product.name} to cart');
      final cartItem = CartItemEntity(
        cartItemId: null,
        productId: product.productId ?? '',
        productName: product.name,
        productType: 'food',
        productPrice: product.price,
        productDescription: product.description ?? '',
        productImage: product.image,
        categoryId: product.categoryId,
        restaurantId: product.restaurantId,
        isAvailable: product.isAvailable ?? true,
        categoryName: product.categoryName,
        categoryImage: product.categoryImage,
        restaurantName: product.restaurantName,
        restaurantImage: product.restaurantImage,
        restaurantLocation: product.restaurantLocation,
        restaurantContact: product.restaurantContact,
        quantity: 1,
        price: product.price,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      print('📋 MenuView: Created cart item - ${cartItem.productName} (ID: ${cartItem.productId})');
      context.read<CartViewModel>().add(AddToCart(cartItem));
      print('✅ MenuView: AddToCart event dispatched');
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('${product.name} added to cart!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () {
              print('🛒 MenuView: User clicked View Cart');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartView()),
              );
            },
          ),
        ),
      );
    } catch (e) {
      print('❌ MenuView: Error adding to cart - $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add ${product.name} to cart'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
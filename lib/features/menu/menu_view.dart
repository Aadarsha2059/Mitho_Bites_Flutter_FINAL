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
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;







class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String? userAddress;
  bool isLoadingAddress = true;
  
  // Barometer variables
  BarometerEvent? _barometerEvent;
  final List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  bool _isBarometerAvailable = true;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
    _initializeBarometer();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _searchController.dispose();
    super.dispose();
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

  void _initializeBarometer() {
    _streamSubscriptions.add(
      barometerEventStream().listen(
        (BarometerEvent event) {
          setState(() {
            _barometerEvent = event;
          });
        },
        onError: (e) {
          setState(() {
            _isBarometerAvailable = false;
          });
        },
        cancelOnError: true,
      ),
    );
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
                _buildWeatherWidget(),
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
            controller: _searchController,
            onChanged: (value) {
              context.read<MenuViewModel>().add(SearchCategoriesEvent(value));
            },
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              suffixIcon: IconButton(
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.orange),
                onPressed: _listenVoiceSearch,
              ),
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

  void _listenVoiceSearch() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceInput = val.recognizedWords;
              _searchController.text = _voiceInput;
              _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
            });
            context.read<MenuViewModel>().add(SearchCategoriesEvent(_voiceInput));
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Widget _buildWeatherWidget() {
    if (!_isBarometerAvailable) {
      return const SizedBox.shrink();
    }

    final pressure = _barometerEvent?.pressure ?? 1013.25; // Default sea level pressure
    final weatherCondition = _getWeatherCondition(pressure);
    final foodRecommendations = _getFoodRecommendations(pressure);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getWeatherIcon(pressure),
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Weather & Food Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atmospheric Pressure',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pressure.toStringAsFixed(1)} hPa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weatherCondition,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Foods',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      foodRecommendations,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeatherCondition(double pressure) {
    if (pressure < 1000) {
      return 'Low Pressure - Stormy weather likely';
    } else if (pressure < 1013) {
      return 'Below Average - Rain possible';
    } else if (pressure < 1020) {
      return 'Normal - Pleasant weather';
    } else if (pressure < 1030) {
      return 'Above Average - Clear skies';
    } else {
      return 'High Pressure - Very dry weather';
    }
  }

  String _getFoodRecommendations(double pressure) {
    if (pressure < 1000) {
      return 'Warm soups, hot tea, comfort foods';
    } else if (pressure < 1013) {
      return 'Light meals, fresh salads, warm drinks';
    } else if (pressure < 1020) {
      return 'Balanced meals, grilled items, fresh fruits';
    } else if (pressure < 1030) {
      return 'Light snacks, cold drinks, fresh vegetables';
    } else {
      return 'Hydrating foods, cold dishes, fruits';
    }
  }

  IconData _getWeatherIcon(double pressure) {
    if (pressure < 1000) {
      return Icons.thunderstorm;
    } else if (pressure < 1013) {
      return Icons.cloudy_snowing;
    } else if (pressure < 1020) {
      return Icons.wb_sunny;
    } else if (pressure < 1030) {
      return Icons.wb_sunny_outlined;
    } else {
      return Icons.wb_sunny_rounded;
    }
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
        // Show status message if searching
        if (state.searchQuery.isNotEmpty)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 4),
                child: Text(
                  state.searchStatus == 'available'
                      ? 'Available'
                      : 'Currently unavailable',
                  style: TextStyle(
                    color: state.searchStatus == 'available' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (state.filteredCategories.isNotEmpty)
                SizedBox(
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
                ),
              if (state.filteredRestaurants.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Restaurants:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ...state.filteredRestaurants.map((r) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.restaurant, size: 18, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text(r, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              if (state.filteredCategories.isEmpty && state.filteredRestaurants.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 8),
                  child: Text('No categories or restaurants found.', style: TextStyle(color: Colors.red[400], fontSize: 13)),
                ),
            ],
          );
        // Default: show all categories as chips
        final categoriesToShow = state.searchQuery.isNotEmpty ? state.filteredCategories : state.categories;
        if (categoriesToShow.isEmpty) {
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
            itemCount: categoriesToShow.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categoriesToShow[index];
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
          child: _ProductGrid(
            categoryId: state.selectedCategoryId!,
            searchQuery: state.searchQuery,
          ),
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
  final String searchQuery;
  const _ProductGrid({required this.categoryId, required this.searchQuery});

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
          // Filter products by search query if present
          final products = searchQuery.isNotEmpty
              ? state.products.where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList()
              : state.products;
          if (products.isEmpty) {
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
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
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
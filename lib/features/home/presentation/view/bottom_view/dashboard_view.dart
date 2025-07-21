import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';
import 'package:fooddelivery_b/features/food_category/presentation/state/category_state.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_event.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view_model/category_view_model.dart';
import 'package:fooddelivery_b/miscellaneous/model/dashboard_model.dart';
import 'package:fooddelivery_b/features/menu/menu_view.dart';
import 'package:fooddelivery_b/features/more_options_bottom_navigation/more_view.dart';
import 'package:fooddelivery_b/miscellaneous/view/partypalace_view.dart';
import 'package:fooddelivery_b/features/food_category/presentation/view/category_list_view.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_view_model.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/state/restaurant_state.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_event.dart';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:fooddelivery_b/features/order/presentation/view_model/order_view_model.dart';
import 'package:fooddelivery_b/app/constant/api_endpoints.dart';


class DashboardView extends StatefulWidget {
  final String currentUsername;
  
  const DashboardView({super.key, this.currentUsername = 'User'});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with WidgetsBindingObserver {
  final DashboardModel model = DashboardModel();
  int _selectedIndex = 0;
  List<Map<String, String>>? _recentlyOrderedDynamic;
  bool _isFetchingOrders = false;
  String? _orderFetchError;

  // Image slider state
  final List<String> _sliderImages = [
    'assets/homepage_images/thakaliiiii.png',
    'assets/homepage_images/momomo.png',
    'assets/homepage_images/yomariii.png',
    'assets/homepage_images/selroti.png',
  ];
  
  // Captions for each image
  final List<String> _sliderCaptions = [
    '🍛 Authentic Thakali Set - Traditional Nepali Delight',
    '🥟 Steamed Momos - Perfect Dumplings Every Time',
    '🍡 Sweet Yomari - Festive Rice Dumplings',
    '🥖 Crispy Sel Roti - Traditional Rice Donuts',
  ];
  
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  AccelerometerEvent? _lastAccel;
  DateTime? _lastShakeTime;
  Map<String, String?>? _latestAdditions;
  bool _showLatestBanner = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startSlider();
    _fetchLatestAdditions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryViewModel>().add(const LoadCategoriesEvent());
      context.read<RestaurantViewModel>().add(const LoadRestaurantsEvent());
    });
    _startAccelListener();
  }

  void _startSlider() {
    _sliderTimer?.cancel();
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _sliderImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchLatestAdditions() async {
    try {
      final response = await http.get(Uri.parse('${ApiEndpoints.serverAddress}/api/dashboard/latest-additions'));
      print('Latest additions response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final additions = {
            'restaurant': data['data']['restaurant'],
            'category': data['data']['category'],
            'food': data['data']['food'],
          };
          // Only show notification if at least one is non-null
          if (additions.values.any((v) => v != null && v.toString().trim().isNotEmpty)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final msg = [
                if (additions['restaurant'] != null) 'Restaurant: ${additions['restaurant']}',
                if (additions['category'] != null) 'Category: ${additions['category']}',
                if (additions['food'] != null) 'Food: ${additions['food']}',
              ].join('  |  ');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white),
                      const SizedBox(width: 10),
                      Expanded(child: Text('New on Mitho Bites! $msg', style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  backgroundColor: Colors.deepOrange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  duration: const Duration(seconds: 5),
                  elevation: 8,
                ),
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching latest additions: $e');
    }
  }

  Future<void> _fetchRecentlyOrdered(BuildContext context) async {
    setState(() {
      _isFetchingOrders = true;
      _orderFetchError = null;
    });
    try {
      final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
      await orderViewModel.fetchOrders();
      final orders = orderViewModel.orders;
      if (orders.isNotEmpty) {
        final recent = orders.take(2).map((order) {
          final firstItem = order.items.isNotEmpty ? order.items[0] : null;
          String image = "assets/images/item_1.png";
          if (firstItem != null) {
            if (firstItem['productId'] is Map && firstItem['productId']['image'] != null) {
              image = firstItem['productId']['image'];
            }
          }
          String name = "Ordered Item";
          if (firstItem != null) {
            if (firstItem['productName'] != null && firstItem['productName'] is String) {
              name = firstItem['productName'] as String;
            } else if (firstItem['productId'] is Map && firstItem['productId']['name'] != null) {
              name = firstItem['productId']['name'].toString();
            }
          }
          return {
            "image": image,
            "name": name
          };
        }).toList();
        setState(() {
          _recentlyOrderedDynamic = recent.cast<Map<String, String>>();
        });
      } else {
        setState(() {
          _recentlyOrderedDynamic = null;
        });
      }
    } catch (e) {
      setState(() {
        _orderFetchError = "Failed to fetch orders";
        _recentlyOrderedDynamic = null;
      });
    } finally {
      setState(() {
        _isFetchingOrders = false;
      });
    }
  }

  void _startAccelListener() {
    _accelSub?.cancel();
    _accelSub = accelerometerEvents.listen((event) {
      if (_lastAccel != null) {
        final dx = (event.x - _lastAccel!.x).abs();
        final dy = (event.y - _lastAccel!.y).abs();
        final dz = (event.z - _lastAccel!.z).abs();
        final now = DateTime.now();
        if ((dx > 8.0 || dy > 8.0 || dz > 8.0) && (_lastShakeTime == null || now.difference(_lastShakeTime!) > Duration(seconds: 2))) {
          _lastShakeTime = now;
          if (mounted) {
            _fetchRecentlyOrdered(context);
            setState(() {});
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text('Dashboard refreshed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                backgroundColor: Colors.deepOrange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
                elevation: 8,
              ),
            );
          }
        }
      }
      _lastAccel = event;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _accelSub?.cancel();
    model.disposeControllers();
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAccelListener();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _accelSub?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/logo.png"),
        ),
        title: const Text(
          "Mitho-Bites Nepal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Roboto',
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(),
          const ChatBotView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const MenuView();
      case 2:
        return PartyPalaceView();
      case 3:
        return const MoreView();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        final categoryViewModel = context.read<CategoryViewModel>();
        final restaurantViewModel = context.read<RestaurantViewModel>();
        categoryViewModel.add(const LoadCategoriesEvent());
        restaurantViewModel.add(const LoadRestaurantsEvent());
        await _fetchRecentlyOrdered(context);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_latestAdditions != null && _showLatestBanner)
            MaterialBanner(
              backgroundColor: Colors.deepOrange.shade50,
              leading: const Icon(Icons.new_releases, color: Colors.deepOrange, size: 36),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('New on Mitho Bites!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange)),
                  if (_latestAdditions!['restaurant'] != null)
                    Text('Restaurant: ${_latestAdditions!['restaurant']}', style: const TextStyle(fontSize: 15)),
                  if (_latestAdditions!['category'] != null)
                    Text('Category: ${_latestAdditions!['category']}', style: const TextStyle(fontSize: 15)),
                  if (_latestAdditions!['food'] != null)
                    Text('Food: ${_latestAdditions!['food']}', style: const TextStyle(fontSize: 15)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => setState(() => _showLatestBanner = false),
                  child: const Text('Dismiss', style: TextStyle(color: Colors.deepOrange)),
                ),
              ],
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          // Welcome message with loading indicator
          BlocBuilder<CategoryViewModel, CategoryState>(
            builder: (context, categoryState) {
              return BlocBuilder<RestaurantViewModel, RestaurantState>(
                builder: (context, restaurantState) {
                  final isLoading = categoryState.isLoading || restaurantState.isLoading;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Namaste, ${widget.currentUsername}! 🙏",
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            _RefreshDashboardIcon(onRefresh: () async {
                              if (mounted) {
                                setState(() {
                                  // Optionally trigger a loading state or reload logic here
                                });
                              }
                              // Add your dashboard refresh logic here if needed
                              if (mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: const [
                                        Icon(Icons.check_circle, color: Colors.white, size: 22),
                                        SizedBox(width: 10),
                                        Text('Dashboard refreshed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      ],
                                    ),
                                    backgroundColor: Colors.deepOrange,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    duration: const Duration(seconds: 2),
                                    elevation: 8,
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                      if (isLoading) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Loading delicious food for you...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Kathmandu, Nepal",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildImageSlider(),
          const SizedBox(height: 24),
          _buildSectionTitle("🍱 Food Categories"),
          _buildHorizontalCategoryList(),
          const SizedBox(height: 24),
          _buildSectionTitle("🔥 Popular Restaurants"),
          _buildRestaurantList(),
          const SizedBox(height: 24),
          _buildSectionTitle("⭐ Most Loved Dishes"),
          _buildHorizontalCardList(model.mostPopArr),
          const SizedBox(height: 24),
          _buildSectionTitle("🕘 Recently Ordered"),
          if (_isFetchingOrders)
            const Center(child: CircularProgressIndicator())
          else ...[
            ...model.recentArr.map((item) => _buildListTile(item['image']!, item['name']!)),
            if (_recentlyOrderedDynamic != null && _recentlyOrderedDynamic!.isNotEmpty)
              ..._recentlyOrderedDynamic!.map((item) => _buildListTile(item['image']!, item['name']!)),
          ],
          const SizedBox(height: 100),
        ],
      ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: model.txtSearch,
      decoration: InputDecoration(
        hintText: "Search for momo, thakali, sel roti...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    final double sliderHeight = MediaQuery.of(context).size.width * 0.45;
    return Column(
      children: [
        SizedBox(
          height: sliderHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _sliderImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.asset(
                          _sliderImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        // Gradient overlay for better text readability
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Caption text
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _sliderCaptions[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_sliderImages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.deepOrange
                              : Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            if (_currentPage == index)
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          if (title.contains('Category') || title.contains('category'))
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<CategoryViewModel>(),
                      child: const CategoryListView(),
                    ),
                  ),
                );
              },
              child: const Text(
                "View All",
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            )
          else
            TextButton(
              onPressed: () {},
              child: const Text(
                "View All",
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCategoryList() {
    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.errorMessage != null) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryViewModel>().add(const LoadCategoriesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.categories.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: Text('No categories available'),
            ),
          );
        }

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return _buildCategoryCard(category.image ?? '', category.name);
            },
          ),
        );
      },
    );
  }

  Widget _buildRestaurantList() {
    return BlocBuilder<RestaurantViewModel, RestaurantState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.errorMessage != null) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RestaurantViewModel>().add(const LoadRestaurantsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.restaurants.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No restaurants available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: state.restaurants.map((restaurant) {
            return GestureDetector(
              onTap: () {
                // Navigate to restaurant menu
                setState(() {
                  _selectedIndex = 1; // Switch to menu tab
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${restaurant.name} menu'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: restaurant.image != null && restaurant.image!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: restaurant.image!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) {
                              print('Error loading restaurant image: $url - $error');
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(Icons.restaurant, size: 30, color: Colors.grey),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.restaurant, size: 30, color: Colors.grey),
                        ),
                  title: Text(
                    restaurant.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              restaurant.location,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.contact,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepOrange),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCategoryCard(String image, String name) {
    return GestureDetector(
      onTap: () {
        // Navigate to menu with category filter
        setState(() {
          _selectedIndex = 1; // Switch to menu tab
        });
        // You can also pass the category name to filter menu items
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Browsing $name category'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          print('Error loading category image: $url - $error');
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.restaurant,
                              size: 30,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.restaurant,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String image, String title) {
    final bool isNetwork = image.startsWith('http://') || image.startsWith('https://');
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, size: 30, color: Colors.grey),
                  ),
                )
              : Image.asset(image, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        subtitle: const Text(
          "Traditional Cuisine · 4.9 ⭐ (120+ reviews)",
          style: TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }

  Widget _buildHorizontalCardList(List<Map<String, String>> items) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return _buildHorizontalCard(item['image']!, item['name']!);
        },
      ),
    );
  }

  Widget _buildHorizontalCard(String image, String title) {
    final bool isNetwork = image.startsWith('http://') || image.startsWith('https://');
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: isNetwork
                ? CachedNetworkImage(
                    imageUrl: image,
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 100,
                      width: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 100,
                      width: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 30, color: Colors.grey),
                    ),
                  )
                : Image.asset(image, height: 100, width: 150, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "4.9 ⭐ · Authentic Taste",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

class _RefreshDashboardIcon extends StatefulWidget {
  final Future<void> Function() onRefresh;
  const _RefreshDashboardIcon({required this.onRefresh});

  @override
  State<_RefreshDashboardIcon> createState() => _RefreshDashboardIconState();
}

class _RefreshDashboardIconState extends State<_RefreshDashboardIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    _controller.repeat();
    // Remove all SnackBars before refresh to avoid red background
    ScaffoldMessenger.of(context).clearSnackBars();
    await widget.onRefresh();
    await Future.delayed(const Duration(milliseconds: 600));
    _controller.stop();
    setState(() => _isRefreshing = false);
    // Show dashboard refreshed message after refresh is complete
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text('Dashboard refreshed!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          backgroundColor: Colors.deepOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
          elevation: 8,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleRefresh,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _isRefreshing ? 0.7 + 0.3 * (0.5 + 0.5 * (1 + _controller.value).abs()) : 1.0,
            child: Transform.rotate(
              angle: _controller.value * 6.3,
              child: Icon(
                Icons.refresh,
                color: _isRefreshing ? Colors.deepOrange : Colors.grey[700],
                size: 26,
                shadows: _isRefreshing
                    ? [
                        Shadow(
                          color: Colors.deepOrangeAccent.withOpacity(0.5),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
            ),
          );
        },
      ),
    );
  }
}

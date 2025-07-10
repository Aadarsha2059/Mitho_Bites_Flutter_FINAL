import 'package:flutter/material.dart';

class KhanaKhajanaView extends StatefulWidget {
  const KhanaKhajanaView({super.key});

  @override
  State<KhanaKhajanaView> createState() => _KhanaKhajanaViewState();
}

class _KhanaKhajanaViewState extends State<KhanaKhajanaView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  int _selectedCategoryIndex = 0;
  bool _showFacts = false;

  final List<FoodCategory> _categories = [
    FoodCategory(
      name: 'Vegetarian Delights',
      icon: Icons.eco,
      color: Colors.green,
      gradient: [Colors.green.shade400, Colors.green.shade700],
      description: 'Fresh, healthy, and delicious plant-based foods',
      items: [
        'Dal Bhat (Rice & Lentils)',
        'Saag Paneer (Spinach & Cheese)',
        'Aloo Gobi (Potato & Cauliflower)',
        'Baingan Bharta (Roasted Eggplant)',
        'Chana Masala (Chickpea Curry)',
        'Palak Paneer (Spinach & Cottage Cheese)',
        'Mixed Vegetable Curry',
        'Mushroom Masala',
        'Tofu Stir Fry',
        'Quinoa Bowl',
      ],
      image: 'assets/images/vegetarian_food.png',
    ),
    FoodCategory(
      name: 'Fresh Fruits',
      icon: Icons.apple,
      color: Colors.orange,
      gradient: [Colors.orange.shade400, Colors.red.shade600],
      description: 'Nature\'s sweet and nutritious gifts',
      items: [
        'Mango (Aam)',
        'Banana (Kera)',
        'Apple (Syau)',
        'Orange (Suntala)',
        'Pomegranate (Anar)',
        'Grapes (Angur)',
        'Pineapple (Bhainse)',
        'Papaya (Mewa)',
        'Guava (Amba)',
        'Strawberry (Strawberry)',
      ],
      image: 'assets/images/fruits.png',
    ),
    FoodCategory(
      name: 'Non-Vegetarian',
      icon: Icons.restaurant,
      color: Colors.red,
      gradient: [Colors.red.shade400, Colors.red.shade700],
      description: 'Rich and flavorful meat-based dishes',
      items: [
        'Chicken Curry (Kukhura ko Masu)',
        'Mutton Curry (Khasi ko Masu)',
        'Fish Curry (Machha ko Masu)',
        'Chicken Biryani',
        'Lamb Rogan Josh',
        'Tandoori Chicken',
        'Butter Chicken',
        'Fish Tikka',
        'Chicken Tikka Masala',
        'Mutton Seekh Kebab',
      ],
      image: 'assets/images/non_veg.png',
    ),
    FoodCategory(
      name: 'Miscellaneous',
      icon: Icons.category,
      color: Colors.purple,
      gradient: [Colors.purple.shade400, Colors.indigo.shade600],
      description: 'Unique and diverse culinary creations',
      items: [
        'Momos (Dumplings)',
        'Chow Mein',
        'Fried Rice',
        'Noodles',
        'Pizza',
        'Burger',
        'Sandwich',
        'Pasta',
        'Sushi',
        'Tacos',
      ],
      image: 'assets/images/misc_food.png',
    ),
  ];

  final List<String> _amazingFacts = [
    '🍎 Apples float in water because 25% of their volume is air!',
    '🥕 Carrots were originally purple, not orange!',
    '🍌 Bananas are berries, but strawberries aren\'t!',
    '🥚 The color of an egg yolk indicates the hen\'s diet!',
    '🍯 Honey never spoils - archaeologists found 3,000-year-old honey that was still edible!',
    '🌶️ Hot peppers get their heat from a chemical called capsaicin!',
    '🥜 Peanuts are not nuts - they\'re legumes!',
    '🍫 Chocolate was once used as currency by the Aztecs!',
    '🥛 Milk is naturally white because it reflects all light wavelengths!',
    '🍕 The first pizza was created in Naples, Italy in 1889!',
    '🥑 Avocados are fruits, and they\'re technically berries!',
    '🍍 Pineapples take 2-3 years to grow from seed to fruit!',
    '🥬 Lettuce is 96% water!',
    '🍇 Grapes explode when you put them in the microwave!',
    '🥜 Cashews grow on the outside of a fruit called a cashew apple!',
    '🍯 Bees must visit 2 million flowers to make 1 pound of honey!',
    '🥕 The world\'s largest carrot was over 19 feet long!',
    '🍎 There are over 7,500 varieties of apples worldwide!',
    '🥜 Almonds are seeds, not nuts!',
    '🍫 White chocolate isn\'t actually chocolate - it contains no cocoa solids!',
    '🥚 The average hen lays 250-300 eggs per year!',
    '🍯 Honey is the only food that includes all substances necessary to sustain life!',
    '🌶️ The hottest pepper in the world is the Carolina Reaper!',
    '🥜 Peanut butter was invented as a protein substitute for people with bad teeth!',
    "🍕 The most expensive pizza in the world costs 12,000!",
    '🥑 Avocados are toxic to most animals, including cats and dogs!',
    '🍍 Pineapples are actually a collection of berries that have fused together!',
    '🥬 Spinach has more iron than beef per calorie!',
    '🍇 Grapes are one of the oldest cultivated fruits, dating back 8,000 years!',
    '🥜 Pistachios are actually seeds, not nuts!',
    '🍯 Bees have to fly 55,000 miles to make one pound of honey!',
    '🥕 Carrots can help you see in the dark due to their vitamin A content!',
    '🍎 Apple seeds contain cyanide, but you\'d need to eat hundreds to be affected!',
    '🥜 Walnuts are the oldest tree food known to man!',
    '🍫 Chocolate was first consumed as a bitter drink, not as candy!',
    '🥚 The color of an eggshell doesn\'t affect its nutritional value!',
    '🍯 Honey is the only food that never spoils!',
    '🌶️ Chili peppers evolved their heat to prevent mammals from eating them!',
    '🥜 Peanuts are used to make dynamite!',
    '🍕 Pizza was originally a poor man\'s food in Naples!',
    '🥑 Avocados are called "alligator pears" because of their rough skin!',
    '🍍 Pineapples are native to South America, not Hawaii!',
    '🥬 Kale is actually a form of cabbage!',
    '🍇 Grapes are 80% water!',
    '🥜 Cashews are always sold shelled because the shell is toxic!',
    '🍯 Bees have to fly 55,000 miles to make one pound of honey!',
    '🥕 The orange carrot was developed in the Netherlands to honor the Dutch royal family!',
    '🍎 Apple trees can live for over 100 years!',
    '🥜 Almonds are mentioned in the Bible!',
    '🍫 Chocolate was once so valuable that it was used as money!',
    '🥚 The average person eats 250 eggs per year!',
    '🍯 Honey is the only food that contains pinocembrin, an antioxidant that improves brain function!',
    '🌶️ Hot peppers can help you lose weight by boosting metabolism!',
    '🥜 Peanut butter was first introduced at the 1904 World\'s Fair!',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.stop();
    _pulseController.stop();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Khana Khajana',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          semanticsLabel: 'Khana Khajana',
        ),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeader(),
                _buildCategoryTabs(),
                _buildCategoryContent(),
                _buildDidYouKnowSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.orange,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Khana Khajana',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          semanticsLabel: 'Khana Khajana',
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade700,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value * 0.8,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.purple.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Explore Food Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          semanticsLabel: 'Explore Food Categories',
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Discover amazing facts about your favorite foods!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          semanticsLabel: 'Discover amazing facts about your favorite foods!',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      '${_categories.length} Categories • ${_amazingFacts.length} Amazing Facts',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      semanticsLabel: '${_categories.length} Categories, ${_amazingFacts.length} Amazing Facts',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 15),
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSelected 
                    ? category.gradient 
                    : [Colors.grey.shade200, Colors.grey.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: category.color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    semanticsLabel: category.name,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryContent() {
    final selectedCategory = _categories[_selectedCategoryIndex];
    
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: selectedCategory.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    selectedCategory.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCategory.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        semanticsLabel: selectedCategory.name,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedCategory.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        semanticsLabel: selectedCategory.description,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    selectedCategory.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              ],
            ),
          ),
          
          // Category Items
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.list, color: selectedCategory.color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Popular Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selectedCategory.color,
                      ),
                      semanticsLabel: 'Popular Items',
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: selectedCategory.items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedCategory.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedCategory.color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selectedCategory.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedCategory.items[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selectedCategory.color.shade700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              semanticsLabel: selectedCategory.items[index],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDidYouKnowSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade100,
            Colors.orange.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade400,
                  Colors.orange.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Did You Know?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        semanticsLabel: 'Did You Know?',
                      ),
                      Text(
                        'Amazing food facts that will blow your mind!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        semanticsLabel: 'Amazing food facts that will blow your mind!',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showFacts = !_showFacts;
                    });
                  },
                  icon: Icon(
                    _showFacts ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          
          // Facts Content
          if (_showFacts)
            Container(
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxHeight: 400),
              child: Column(
                children: [
                  Text(
                    '${_amazingFacts.length} Amazing Food Facts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                    semanticsLabel: '${_amazingFacts.length} Amazing Food Facts',
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _amazingFacts.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _amazingFacts[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                  semanticsLabel: _amazingFacts[index],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_emotions, color: Colors.orange.shade600, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'These facts show how amazing and diverse our food world is! Every ingredient has a story to tell.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                            semanticsLabel: 'These facts show how amazing and diverse our food world is! Every ingredient has a story to tell.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

extension on Color {
  Null get shade700 => null;
}

class FoodCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final String description;
  final List<String> items;
  final String image;

  FoodCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.gradient,
    required this.description,
    required this.items,
    required this.image,
  });
}
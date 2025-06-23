import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List<Map<String, String>> menuArr = [
    {
      "name": "Food",
      "image": "assets/images/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Beverages",
      "image": "assets/images/menu_2.png",
      "items_count": "220",
    },
    {
      "name": "Desserts",
      "image": "assets/images/menu_3.png",
      "items_count": "155",
    },
    {
      "name": "Promotions",
      "image": "assets/images/menu_4.png",
      "items_count": "25",
    },
  ];

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Main content
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Decorative left panel
              Container(
                margin: const EdgeInsets.only(top: 180),
                width: media.width * 0.25,
                height: media.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
              ),

              // Main Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 46),

                      // App Logo and Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/logo.png",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Mitho_Bites",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                // Future navigation to order view
                              },
                              icon: Image.asset(
                                "assets/images/shopping_cart.png",
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Search Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: txtSearch,
                          decoration: InputDecoration(
                            hintText: "Search food items...",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "assets/images/search.png",
                                width: 20,
                                height: 20,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Menu Categories
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Menu Categories",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: menuArr.length,
                              itemBuilder: (context, index) {
                                var item = menuArr[index];
                                return _buildMenuCard(item);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Chatbot
          const ChatBotView(),
        ],
      ),
    );
  }

  Widget _buildMenuCard(Map<String, String> item) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item["image"]!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 15),
          Text(
            item["name"]!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "${item["items_count"]!} items",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
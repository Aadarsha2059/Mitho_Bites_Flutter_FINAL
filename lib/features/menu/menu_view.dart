import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fooddelivery_b/features/menu/menu_view_model.dart';
import 'package:fooddelivery_b/features/menu/menu_state.dart';
import 'package:fooddelivery_b/features/menu/menu_event.dart';
import 'package:fooddelivery_b/app/service_locator/service_locator.dart';
import 'package:fooddelivery_b/features/chatbot/presentation/view/chat_bot_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocProvider<MenuViewModel>(
      create: (_) => serviceLocator<MenuViewModel>(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
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
                                onPressed: () {},
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
                              BlocBuilder<MenuViewModel, MenuState>(
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
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: state.categories.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                                    itemBuilder: (context, index) {
                                      final category = state.categories[index];
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 2,
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(14),
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: category.image != null && category.image!.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: category.image!,
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => const SizedBox(
                                                      width: 30,
                                                      height: 30,
                                                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                                    ),
                                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                                                  )
                                                : Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.grey[200],
                                                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                                                  ),
                                          ),
                                          title: Text(
                                            category.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                          subtitle: const Text('Items: (coming soon)'),
                                          onTap: () {
                                            // TODO: Navigate to food products filtered by this category
                                          },
                                        ),
                                      );
                                    },
                                  );
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
            const ChatBotView(),
          ],
        ),
      ),
    );
  }
}
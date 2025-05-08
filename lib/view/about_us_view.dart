import 'package:flutter/material.dart';
import 'dart:async';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  final List<String> aboutTextArr = [
    "Mitho-Bites is a mobile food delivery application developed as part of the academic project for the module Mobile Application Development.",
    "This project is designed and implemented by Aadarsha Babu Dhakal under the guidance of our respected module teacher, Kiran Rana Sir.",
    "The goal of Mitho-Bites is to provide users with a smooth and user-friendly experience for ordering delicious food online within specified city of Nepal.",
    "We have implemented Clean Architecture in our app, ensuring the separation of concerns, scalability, and testability.",
    "From intuitive UI to robust state management and modular code practices, Mitho-Bites reflects modern Flutter development principles.",
    "This project not only demonstrates technical proficiency but also represents a passion for solving real-world problems using mobile technology.",
  ];

  double _opacity = 1.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.3 : 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, size: 24),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "About Us",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cart is under construction."),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart, size: 26),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Blinking Logo
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _opacity,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 120,
                    height: 120,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Welcome to Mitho-Bites",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: aboutTextArr.length,
                itemBuilder: (context, index) {
                  final txt = aboutTextArr[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 25,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            txt,
                            style: const TextStyle(fontSize: 15, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class PartyPalaceView extends StatefulWidget {
  const PartyPalaceView({super.key});

  @override
  State<PartyPalaceView> createState() => _PartyPalaceViewState();
}

class _PartyPalaceViewState extends State<PartyPalaceView> {
  List<Map<String, dynamic>> palaces = [
    {
      "name": "Imperial Palace",
      "image": "assets/images/imperial.png",
      "location": "Kalanki, Kathmandu",
      "rating": 4.8,
      "seats": 300,
      "price": "Rs. 65,000",
    },
    {
      "name": "Smart Palace",
      "image": "assets/images/smart.png",
      "location": "Baneshwor, Kathmandu",
      "rating": 4.5,
      "seats": 250,
      "price": "Rs. 60,000",
    },
    {
      "name": "Taaj Banquet",
      "image": "assets/images/taaj.png",
      "location": "Pulchowk, Lalitpur",
      "rating": 4.9,
      "seats": 350,
      "price": "Rs. 95,000",
    },
    {
      "name": "Sundhara Party Palace",
      "image": "assets/images/bestparty.png",
      "location": "Sundhara, Kathmandu",
      "rating": 4.6,
      "seats": 200,
      "price": "Rs. 55,000",
    },
  ];

  bool _sortAscending = true;
  bool _hasSortedOnce = false;
  late final Stream<GyroscopeEvent> _gyroscopeStream;
  StreamSubscription<GyroscopeEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    // Shuffle palaces on first load
    palaces.shuffle();
    _gyroscopeStream = gyroscopeEvents;
    _subscription = _gyroscopeStream.listen(_onGyroEvent);
  }

  @override
  void dispose() {
    
    _subscription = null;
    super.dispose();
  }

  void _onGyroEvent(GyroscopeEvent event) {
    // Only trigger on significant movement
    if (event.x.abs() > 1.5 || event.y.abs() > 1.5 || event.z.abs() > 1.5) {
      setState(() {
        if (!_hasSortedOnce) {
          // First gyroscope event: sort ascending
          palaces.sort((a, b) => _parsePrice(a["price"]).compareTo(_parsePrice(b["price"])));
          _sortAscending = false;
          _hasSortedOnce = true;
        } else {
          // Alternate: ascending/descending
          if (_sortAscending) {
            palaces.sort((a, b) => _parsePrice(a["price"]).compareTo(_parsePrice(b["price"])));
          } else {
            palaces.sort((a, b) => _parsePrice(b["price"]).compareTo(_parsePrice(a["price"])));
          }
          _sortAscending = !_sortAscending;
        }
      });
    }
  }

  int _parsePrice(String priceStr) {
    // Extract digits from price string like "Rs. 65,000"
    final cleaned = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = min(constraints.maxWidth, 400.0);
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Balloons background (static, visually similar to API/Frontend)
                    ...List.generate(10, (i) =>
                      AnimatedBalloon(
                        left: (maxW / 10) * i + (i % 2 == 0 ? 10 : 30),
                        top: 40.0 + 30 * (i % 3),
                        size: 38.0 + (i % 3) * 10,
                        color: i % 3 == 0
                            ? Colors.pinkAccent.withOpacity(0.18)
                            : i % 3 == 1
                                ? Colors.blueAccent.withOpacity(0.18)
                                : Colors.orangeAccent.withOpacity(0.18),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: maxW,
                        constraints: const BoxConstraints(
                          minWidth: 260,
                          maxWidth: 400,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: Colors.deepOrange.shade100, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 28, color: Colors.grey),
                                onPressed: () => Navigator.of(ctx).pop(),
                                tooltip: 'Close',
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Drop your bookings to our admin:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.deepOrange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Color(0xFFF7F7FA),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepOrange.withOpacity(0.04),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: const [
                                  Text(
                                    'Aadarsha Babu Dhakal',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black87),
                                  ),
                                  SizedBox(height: 4),
                                  SelectableText(
                                    'Email: aadarsha12345@gmail.com',
                                    style: TextStyle(fontSize: 15, color: Colors.black54),
                                  ),
                                  SizedBox(height: 2),
                                  SelectableText(
                                    'Contact: 9800000000',
                                    style: TextStyle(fontSize: 15, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Our team will get in touch with you to confirm your booking and discuss further details.',
                              style: TextStyle(color: Colors.black87, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Thank you for choosing us for your special occasion!',
                              style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Falling Balloons Animation (Upward and Downward) - moved to foreground
                    const FallingBalloons(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Top Party Palaces 🎉",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange.shade600,  // changed to orange
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: palaces.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final palace = palaces[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade50, Colors.white],  // updated gradient start to light orange tint
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      palace["image"],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          palace["name"],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange.shade700,  // match orange tone
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.deepOrangeAccent),
                            const SizedBox(width: 5),
                            Text(
                              palace["location"],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: palace["rating"],
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InfoBadge(
                                icon: Icons.event_seat,
                                label: '${palace["seats"]} Seats'),
                            InfoBadge(
                                icon: Icons.attach_money,
                                label: palace["price"]),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,  // changed button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              _showBookingDialog(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 10),
                              child: Text(
                                "Book Now",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepOrange),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

// AnimatedBalloon widget for festive background
class AnimatedBalloon extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  const AnimatedBalloon({super.key, required this.left, required this.top, required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Icon(
        Icons.emoji_emotions,
        size: size,
        color: color,
        shadows: [
          Shadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class FallingBalloons extends StatefulWidget {
  const FallingBalloons({super.key});

  @override
  State<FallingBalloons> createState() => _FallingBalloonsState();
}

class _FallingBalloonsState extends State<FallingBalloons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int balloonCount = 12;
  final Random _random = Random();
  late List<_BalloonParams> _balloons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
    _balloons = List.generate(balloonCount, (i) {
      final isUp = i % 2 == 0;
      return _BalloonParams(
        left: 20.0 + _random.nextDouble() * 320,
        start: isUp ? 320.0 + _random.nextDouble() * 60 : 0.0 - _random.nextDouble() * 60,
        end: isUp ? 0.0 : 320.0,
        size: 32.0 + _random.nextDouble() * 24,
        color: [
          Colors.pinkAccent.withOpacity(0.7),
          Colors.blueAccent.withOpacity(0.7),
          Colors.orangeAccent.withOpacity(0.7),
          Colors.greenAccent.withOpacity(0.7),
          Colors.purpleAccent.withOpacity(0.7),
        ][i % 5],
        isUp: isUp,
        speed: 0.7 + _random.nextDouble() * 0.6,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: _balloons.map((b) {
              final progress = (_controller.value * b.speed) % 1.0;
              final pos = b.isUp
                  ? b.start - (b.start - b.end) * progress
                  : b.start + (b.end - b.start) * progress;
              return Positioned(
                left: b.left,
                top: pos,
                child: Opacity(
                  opacity: 0.85 - 0.5 * progress,
                  child: _BalloonShape(size: b.size, color: b.color),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _BalloonParams {
  final double left;
  final double start;
  final double end;
  final double size;
  final Color color;
  final bool isUp;
  final double speed;
  _BalloonParams({
    required this.left,
    required this.start,
    required this.end,
    required this.size,
    required this.color,
    required this.isUp,
    required this.speed,
  });
}

class _BalloonShape extends StatelessWidget {
  final double size;
  final Color color;
  const _BalloonShape({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 4,
              height: size * 0.45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

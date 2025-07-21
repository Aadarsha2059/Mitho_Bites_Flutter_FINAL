import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as Math;

class AppTour extends StatefulWidget {
  const AppTour({super.key});

  @override
  State<AppTour> createState() => _AppTourState();
}

class _AppTourState extends State<AppTour> {
  final List<Map<String, String>> stops = [
    {'icon': '🚦', 'label': 'Start', 'desc': 'Welcome to the Highway of Fooding!'},
    {'icon': '🔑', 'label': 'Login', 'desc': 'Sign in to access your dashboard, order food, and manage your profile.'},
    {'icon': '📝', 'label': 'Sign Up', 'desc': 'Create an account to unlock all features and get personalized recommendations!'},
    {'icon': '🏠', 'label': 'Dashboard', 'desc': 'Your home base for recommendations, quick links, and recent activity.'},
    {'icon': '🍽️', 'label': 'Categories', 'desc': 'Browse food categories and discover a variety of cuisines and dishes.'},
    {'icon': '🛒', 'label': 'Cart', 'desc': 'Add your favorite foods to the cart and proceed to checkout.'},
    {'icon': '📦', 'label': 'Order', 'desc': 'Place your order and track its status in real time.'},
    {'icon': '📜', 'label': 'History', 'desc': 'View all your past orders and reorder your favorites.'},
    {'icon': '💬', 'label': 'Feedback', 'desc': 'Leave feedback on your orders to help us improve.'},
    {'icon': '🏁', 'label': 'End', 'desc': 'Thank you! You have reached the end of the highway. Enjoy your journey with Mitho Bites!'},
  ];
  int currentStop = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                height: 520, // Further increased height for more vertical space
                child: AnimatedTurningHighway(
                  stops: stops,
                  currentStop: currentStop,
                  key: ValueKey(currentStop),
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text(
              stops[currentStop]['label']! == 'Start'
                  ? '🚦  Start'
                  : stops[currentStop]['label']!,
              style: stops[currentStop]['label']! == 'Start'
                  ? const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.black, // Black for Start
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    )
                  : theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: stops[currentStop]['label']! == 'Start'
                  ? Text(
                      stops[currentStop]['desc']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black, // Black for Start description
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      stops[currentStop]['desc']!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(stops.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentStop == i ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentStop == i ? Colors.deepOrange : Colors.deepOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStop < stops.length - 1) ...[
                  ElevatedButton.icon(
                    onPressed: currentStop > 0
                        ? () => setState(() => currentStop--)
                        : null,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 18),
                  ElevatedButton.icon(
                    onPressed: currentStop < stops.length - 1
                        ? () => setState(() => currentStop++)
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => _CongratsDialog(),
                      );
                      if (mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.celebration),
                    label: const Text('Finish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Add an animated version of TurningHighway for smooth car movement
class AnimatedTurningHighway extends StatefulWidget {
  final List<Map<String, String>> stops;
  final int currentStop;
  const AnimatedTurningHighway({required this.stops, required this.currentStop, super.key});

  @override
  State<AnimatedTurningHighway> createState() => _AnimatedTurningHighwayState();
}

class _AnimatedTurningHighwayState extends State<AnimatedTurningHighway> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _oldStop = 0;

  // Path points for the car to follow (normalized to width/height), reversed for top-to-bottom
  final List<Offset> _pathPoints = const [
    Offset(0.05, 0.05), // Start (top)
    Offset(0.25, 0.05), // Login
    Offset(0.5, 0.05), // Sign Up
    Offset(0.75, 0.05), // Dashboard
    Offset(1.0, 0.15), // Turn
    Offset(0.75, 0.3), // Categories
    Offset(0.5, 0.3), // Cart
    Offset(0.25, 0.3), // Order
    Offset(0.05, 0.3), // Turn
    Offset(0.25, 0.75), // History
    Offset(0.5, 0.75), // Feedback
    Offset(0.75, 0.75), // End (bottom)
  ];
  // Map stop index to path index for car movement (same order, reversed flow)
  final List<int> _stopToPathIdx = [0, 1, 2, 3, 5, 6, 7, 8, 9, 11];
  
  // 0:Start, 1:Login, 2:SignUp, 3:Dashboard, 4:Categories, 5:Cart, 6:Order, 7:History, 8:Feedback, 9:End

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _oldStop = widget.currentStop;
  }

  @override
  void didUpdateWidget(covariant AnimatedTurningHighway oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStop != widget.currentStop) {
      _oldStop = oldWidget.currentStop;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final height = 520.0;
    return Stack(
      children: [
        TurningHighway(
          stops: widget.stops,
          currentStop: widget.currentStop,
          carBuilder: (context, carPositions) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final fromIdx = _stopToPathIdx[_oldStop.clamp(0, _stopToPathIdx.length - 1)];
                final toIdx = _stopToPathIdx[widget.currentStop.clamp(0, _stopToPathIdx.length - 1)];
                final from = _pathPoints[fromIdx];
                final to = _pathPoints[toIdx];
                final dx = from.dx + (to.dx - from.dx) * _animation.value;
                final dy = from.dy + (to.dy - from.dy) * _animation.value;
                // Car direction: angle in radians
                double angle = 0;
                if (from != to) {
                  angle = (to - from).direction;
                }
                return Positioned(
                  left: width * dx - 24,
                  top: height * dy - 32,
                  child: Transform.rotate(
                    angle: angle,
                    child: const Text('🚗', style: TextStyle(fontSize: 38)),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// Update TurningHighway to accept a carBuilder for animation
class TurningHighway extends StatelessWidget {
  final List<Map<String, String>> stops;
  final int currentStop;
  final Widget Function(BuildContext, List<Offset>)? carBuilder;
  const TurningHighway({required this.stops, required this.currentStop, this.carBuilder, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 32;
    final height = 520.0; // match the new height
    final row1 = stops.sublist(0, 4); // Top row
    final row2 = stops.sublist(4, 7); // Middle row
    final row3 = stops.sublist(7, 10); // Bottom row
    final List<Offset> carPositions = [
      const Offset(0.05, 0.05), // Start
      const Offset(0.25, 0.05), // Login
      const Offset(0.5, 0.05), // Sign Up
      const Offset(0.75, 0.05), // Dashboard
      const Offset(1.0, 0.15), // Turn
      const Offset(0.75, 0.3), // Categories
      const Offset(0.5, 0.3), // Cart
      const Offset(0.25, 0.3), // Order
      const Offset(0.05, 0.3), // Turn
      const Offset(0.25, 0.75), // History
      const Offset(0.5, 0.75), // Feedback
      const Offset(0.75, 0.75), // End
    ];
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // Highway lines
          CustomPaint(
            size: Size(width, height),
            painter: AttractiveHighwayPainter(),
          ),
          // Top row (Start)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(row1.length, (i) {
                final idx = i;
                return _StopIcon(
                  icon: stops[idx]['icon']!,
                  label: stops[idx]['label']!,
                  highlight: currentStop == idx,
                  special: idx == 0 || idx == stops.length - 1,
                );
              }),
            ),
          ),
          // First turn (top right)
          Positioned(
            right: 0,
            top: 38,
            child: CustomPaint(
              size: const Size(60, 60),
              painter: QuarterTurnPainter(clockwise: true),
            ),
          ),
          // Middle row (right to left)
          Positioned(
            left: 0,
            right: 0,
            top: 158, // more space between rows
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(row2.length, (i) {
                final idx = 6 - i;
                return _StopIcon(
                  icon: stops[idx]['icon']!,
                  label: stops[idx]['label']!,
                  highlight: currentStop == idx,
                  special: idx == 0 || idx == stops.length - 1,
                );
              }),
            ),
          ),
          // Second turn (bottom left)
          Positioned(
            left: 0,
            top: 236,
            child: CustomPaint(
              size: const Size(60, 60),
              painter: QuarterTurnPainter(clockwise: false),
            ),
          ),
          // Bottom row (End)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(row3.length, (i) {
                final idx = 7 + i;
                return _StopIcon(
                  icon: stops[idx]['icon']!,
                  label: stops[idx]['label']!,
                  highlight: currentStop == idx,
                  special: idx == 0 || idx == stops.length - 1,
                );
              }),
            ),
          ),
          // Car
          if (carBuilder != null)
            carBuilder!(context, carPositions)
          else
            _CarOnHighway(currentStop: currentStop, carPositions: carPositions, height: height),
        ],
      ),
    );
  }
}

// Draw the full highway path connecting all stops
class FullHighwayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD166)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    // Bottom row
    path.moveTo(size.width * 0.05, size.height * 0.95);
    path.lineTo(size.width * 0.95, size.height * 0.95);
    // First turn
    path.quadraticBezierTo(size.width, size.height * 0.95, size.width, size.height * 0.7);
    // Middle row (right to left)
    path.lineTo(size.width * 0.05, size.height * 0.7);
    // Second turn
    path.quadraticBezierTo(0, size.height * 0.7, 0, size.height * 0.25);
    // Top row
    path.lineTo(size.width * 0.95, size.height * 0.25);
    canvas.drawShadow(path, Colors.deepOrange, 12, false);
    canvas.drawPath(path, paint);
    // Dashed white line
    final dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final dashPath = Path();
    double totalLength = 0;
    for (PathMetric metric in path.computeMetrics()) {
      totalLength += metric.length;
    }
    double dashLength = 24, gapLength = 16, distance = 0;
    for (PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final next = distance + dashLength;
        dashPath.addPath(
          metric.extractPath(distance, next < metric.length ? next : metric.length),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }
    canvas.drawPath(dashPath, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// AttractiveHighwayPainter: more vibrant, with gradient and shadow
class AttractiveHighwayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Gradient gradient = LinearGradient(
      colors: [Color(0xFFFFD166), Color(0xFFFF6B35), Color(0xFF1976D2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    // Draw a soft glow under the highway
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.deepOrange.withOpacity(0.18), Colors.transparent],
        radius: 0.8,
        center: Alignment.center,
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(60)),
      glowPaint,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    // Top row
    path.moveTo(size.width * 0.05, size.height * 0.05);
    path.lineTo(size.width * 0.95, size.height * 0.05);
    // First turn
    path.quadraticBezierTo(size.width, size.height * 0.05, size.width, size.height * 0.3);
    // Middle row (right to left)
    path.lineTo(size.width * 0.05, size.height * 0.3);
    // Second turn
    path.quadraticBezierTo(0, size.height * 0.3, 0, size.height * 0.75);
    // Bottom row
    path.lineTo(size.width * 0.95, size.height * 0.75);
    canvas.drawShadow(path, Colors.deepOrange, 24, false);
    canvas.drawPath(path, paint);
    // Dashed white line
    final dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final dashPath = Path();
    double totalLength = 0;
    for (PathMetric metric in path.computeMetrics()) {
      totalLength += metric.length;
    }
    double dashLength = 32, gapLength = 20, distance = 0;
    for (PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final next = distance + dashLength;
        dashPath.addPath(
          metric.extractPath(distance, next < metric.length ? next : metric.length),
          Offset.zero,
        );
        distance += dashLength + gapLength;
      }
    }
    canvas.drawPath(dashPath, dashPaint);
    // Subtle texture: overlay faint dots
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    for (double t = 0; t < 1; t += 0.04) {
      final metric = path.computeMetrics().first;
      final pos = metric.getTangentForOffset(metric.length * t);
      if (pos != null) {
        canvas.drawCircle(pos.position, 3.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Update _CarOnHighway to support custom car positions and height
class _CarOnHighway extends StatelessWidget {
  final int currentStop;
  final List<Offset>? carPositions;
  final double? height;
  const _CarOnHighway({required this.currentStop, this.carPositions, this.height});

  @override
  Widget build(BuildContext context) {
    final List<Offset> positions = carPositions ?? [
      const Offset(0.0, 1.0),
      const Offset(0.25, 1.0),
      const Offset(0.5, 1.0),
      const Offset(0.75, 1.0),
      const Offset(1.0, 0.85),
      const Offset(0.75, 0.6),
      const Offset(0.5, 0.6),
      const Offset(0.25, 0.6),
      const Offset(0.0, 0.45),
      const Offset(0.0, 0.2),
    ];
    final double h = height ?? 260.0;
    final pos = positions[currentStop.clamp(0, positions.length - 1)];
    return Positioned(
      left: (MediaQuery.of(context).size.width - 32) * pos.dx - 24,
      top: h * pos.dy - 32,
      child: Row(
        children: [
          if (currentStop > 0)
            ...List.generate(3, (i) {
              final opacity = 0.5 - i * 0.15;
              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Opacity(
                  opacity: opacity,
                  child: const Text('💧', style: TextStyle(fontSize: 18)),
                ),
              );
            }),
          const Text('🚗', style: TextStyle(fontSize: 38)),
        ],
      ),
    );
  }
}

class _StopIcon extends StatelessWidget {
  final String icon;
  final String label;
  final bool highlight;
  final bool special;
  const _StopIcon({required this.icon, required this.label, required this.highlight, required this.special});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: special
                ? (label == 'Start' ? const Color(0xFFFFD166) : const Color(0xFF1976D2))
                : Colors.white,
            border: Border.all(
              color: highlight
                  ? Colors.deepOrange
                  : (special ? Colors.deepOrange : Colors.grey.shade400),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(19),
            boxShadow: [
              if (special)
                const BoxShadow(color: Color(0x33FFD166), blurRadius: 8),
            ],
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: special ? Colors.deepOrange : Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class QuarterTurnPainter extends CustomPainter {
  final bool clockwise;
  QuarterTurnPainter({required this.clockwise});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD166)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (clockwise) {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(size.width, size.height, size.width, 0);
    } else {
      path.moveTo(size.width, size.height);
      path.quadraticBezierTo(0, size.height, 0, 0);
    }
    canvas.drawShadow(path, Colors.deepOrange, 8, false);
    canvas.drawPath(path, paint);
    // Dashed white line
    final dashPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final dashPath = Path();
    for (double t = 0; t < 1; t += 0.12) {
      final start = clockwise
          ? Offset(size.width * t, size.height - size.height * t)
          : Offset(size.width * (1 - t), size.height - size.height * t);
      final end = clockwise
          ? Offset(size.width * (t + 0.06), size.height - size.height * (t + 0.06))
          : Offset(size.width * (1 - (t + 0.06)), size.height - size.height * (t + 0.06));
      dashPath.moveTo(start.dx, start.dy);
      dashPath.lineTo(end.dx, end.dy);
    }
    canvas.drawPath(dashPath, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 

// Add a congratulatory dialog with a boom/confetti effect
class _CongratsDialog extends StatefulWidget {
  @override
  State<_CongratsDialog> createState() => _CongratsDialogState();
}

class _CongratsDialogState extends State<_CongratsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        width: 340,
        height: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD166), Color(0xFFFF6B35), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: Colors.deepOrange.withOpacity(0.18), blurRadius: 32, offset: Offset(0, 8)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, color: Colors.white, size: 90, shadows: [Shadow(color: Colors.deepOrange, blurRadius: 16, offset: Offset(0, 4))]),
              const SizedBox(height: 18),
              const Text(
                '🎉 Congratulations! 🎉',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.1,
                  shadows: [Shadow(color: Colors.deepOrange, blurRadius: 8, offset: Offset(0, 2))],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Enjoy the fooding journey!\nYou are entering the login page of the app.',
                  style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w600, shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Bon Appétit! 🍽️',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  elevation: 6,
                ),
                child: const Text('OK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
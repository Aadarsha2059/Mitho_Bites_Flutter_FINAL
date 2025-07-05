import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutAssignmentPage extends StatefulWidget {
  const AboutAssignmentPage({super.key});

  @override
  State<AboutAssignmentPage> createState() => _AboutAssignmentPageState();
}

class _AboutAssignmentPageState extends State<AboutAssignmentPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_AboutSlide> _slides = [
    _AboutSlide(
      image: 'assets/homepage_images/aadarshaaaaaaaa.png',
      title: 'Aadarsha Babu Dhakal',
      subtitle: '34 B  |  BSc (Hons) Computing',
      description: 'Contact for Mitho-Bites queries:',
      details: [
        _DetailRow(icon: Icons.email, text: 'aadarsha@gmail.com'),
        _DetailRow(icon: Icons.phone, text: '9864530000'),
      ],
      badge: 'Student',
      badgeColor: Colors.deepOrange,
    ),
    _AboutSlide(
      image: 'assets/homepage_images/sir.png',
      title: 'Kiran Rana',
      subtitle: 'HOD, BSc (Hons) Computing',
      description: 'Supervisor for Mitho Bites.',
      details: [
        _DetailRow(icon: FontAwesomeIcons.userTie, text: 'Supervisor')
      ],
      badge: 'Faculty',
      badgeColor: Colors.blueAccent,
    ),
    _AboutSlide(
      image: 'assets/homepage_images/softwaricaa.png',
      title: 'Softwarica College',
      subtitle: 'Dillibazar, Kathmandu',
      description: 'Fostering innovation in IT education.',
      details: [
        _DetailRow(icon: FontAwesomeIcons.school, text: 'Institution')
      ],
      badge: 'College',
      badgeColor: Colors.green,
    ),
  ];

  void _goToPage(int page) {
    if (page >= 0 && page < _slides.length) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        final double sliderHeight = maxHeight * 0.45; // Reduced slightly for better fit
        final double imageMaxHeight = sliderHeight * 0.50; // Further reduced
        final double imageMaxWidth = maxWidth * 0.60; // Adjusted for smaller screens
        final double cardWidth = maxWidth * 0.88; // Adjusted for padding
        final double cardPadding = maxWidth * 0.06; // Increased for balance
        final double fontScale = maxWidth < 360 ? 0.85 : 1.0; // Refined scaling
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              'Help & Support',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            backgroundColor: Colors.deepOrange.withOpacity(0.95),
            elevation: 3,
            shadowColor: Colors.black38,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          body: Stack(
            children: [
              const _AnimatedBackground(),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: sliderHeight,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: _slides.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final slide = _slides[index];
                              return _AnimatedSlide(
                                slide: slide,
                                isActive: _currentPage == index,
                                cardWidth: cardWidth,
                                cardPadding: cardPadding,
                                imageMaxHeight: imageMaxHeight,
                                imageMaxWidth: imageMaxWidth,
                                fontScale: fontScale,
                              );
                            },
                          ),
                          // Next/Prev arrows
                          Positioned(
                            left: 10,
                            top: sliderHeight / 2 - 24,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: _currentPage > 0 ? Colors.deepOrange : Colors.grey,
                                size: 30,
                              ),
                              onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: sliderHeight / 2 - 24,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: _currentPage < _slides.length - 1 ? Colors.deepOrange : Colors.grey,
                                size: 30,
                              ),
                              onPressed: _currentPage < _slides.length - 1 ? () => _goToPage(_currentPage + 1) : null,
                            ),
                          ),
                          // Dots
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_slides.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  width: _currentPage == index ? 30 : 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.deepOrange
                                        : Colors.deepOrange.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      if (_currentPage == index)
                                        const BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
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
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation.drive(Tween(begin: 0.8, end: 1.0)),
                            child: child,
                          ),
                        );
                      },
                      child: _Badge(
                        key: ValueKey(_slides[_currentPage].badge),
                        text: _slides[_currentPage].badge,
                        color: _slides[_currentPage].badgeColor,
                        fontScale: fontScale,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.deepOrange, size: 20 * fontScale),
                              const SizedBox(width: 10),
                              Flexible(
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Colors.deepOrange,
                                        Color(0xFF1976D2),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'Assignment 2025 | Fifth Semester | BSc (Hons) Computing',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14 * fontScale,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/homepage_images/softwaricaa.png',
                                height: 30 * fontScale,
                                width: 30 * fontScale,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  'Softwarica College, Dillibazar, Kathmandu',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5 * fontScale,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
      },
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();
  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange.withOpacity(0.15 + 0.10 * _animation.value),
                Colors.white,
                const Color(0xFF1976D2).withOpacity(0.08 + 0.08 * (1 - _animation.value)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSlide extends StatelessWidget {
  final _AboutSlide slide;
  final bool isActive;
  final double cardWidth;
  final double cardPadding;
  final double imageMaxHeight;
  final double imageMaxWidth;
  final double fontScale;
  const _AnimatedSlide({
    required this.slide,
    required this.isActive,
    required this.cardWidth,
    required this.cardPadding,
    required this.imageMaxHeight,
    required this.imageMaxWidth,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: cardWidth,
        padding: EdgeInsets.all(cardPadding),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Adjusted margins
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // Increased opacity for better contrast
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.deepOrange.withOpacity(0.25) : Colors.black12,
              blurRadius: isActive ? 40 : 16,
              offset: const Offset(0, 10),
              spreadRadius: 1,
            ),
          ],
          border: isActive
              ? Border.all(color: Colors.deepOrange, width: 3)
              : Border.all(color: Colors.grey.withOpacity(0.2), width: 1.5),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: imageMaxHeight,
                  maxWidth: imageMaxWidth,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    slide.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red, size: 40),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                slide.title,
                style: TextStyle(
                  fontSize: 17 * fontScale,
                  fontWeight: FontWeight.w800,
                  color: Colors.deepOrange,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                slide.subtitle,
                style: TextStyle(
                  fontSize: 12.5 * fontScale,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  slide.description,
                  style: TextStyle(
                    fontSize: 11.5 * fontScale,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              ...slide.details.map((detail) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: detail,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final double fontScale;
  const _Badge({super.key, required this.text, required this.color, required this.fontScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * fontScale, vertical: 7 * fontScale), // Fixed EdgeInsets syntax
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            text == 'Student'
                ? FontAwesomeIcons.userGraduate
                : text == 'Faculty'
                    ? FontAwesomeIcons.userTie
                    : FontAwesomeIcons.school,
            color: color,
            size: 18 * fontScale,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.5 * fontScale,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSlide {
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final List<Widget> details;
  final String badge;
  final Color badgeColor;

  _AboutSlide({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.details,
    required this.badge,
    required this.badgeColor,
  });
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepOrange, size: 15),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                color: Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
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
        final double sliderHeight = maxHeight * 0.48;
        final double imageMaxHeight = sliderHeight * 0.6;
        final double imageMaxWidth = maxWidth * 0.7;
        final double cardWidth = maxWidth * 0.92;
        final double cardPadding = maxWidth * 0.04;
        final double fontScale = maxWidth < 350 ? 0.85 : 1.0;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Help & Support'),
            backgroundColor: Colors.deepOrange.withOpacity(0.95),
            elevation: 0,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              const _AnimatedBackground(),
              SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 18),
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
                            left: 0,
                            top: sliderHeight / 2 - 24,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: _currentPage > 0 ? Colors.deepOrange : Colors.grey, size: 28),
                              onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: sliderHeight / 2 - 24,
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios, color: _currentPage < _slides.length - 1 ? Colors.deepOrange : Colors.grey, size: 28),
                              onPressed: _currentPage < _slides.length - 1 ? () => _goToPage(_currentPage + 1) : null,
                            ),
                          ),
                          // Dots
                          Positioned(
                            bottom: 18,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_slides.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 350),
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  width: _currentPage == index ? 28 : 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.deepOrange
                                        : Colors.deepOrange.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      if (_currentPage == index)
                                        const BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
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
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _Badge(
                        key: ValueKey(_slides[_currentPage].badge),
                        text: _slides[_currentPage].badge,
                        color: _slides[_currentPage].badgeColor,
                        fontScale: fontScale,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline, color: Colors.deepOrange, size: 20 * fontScale),
                              const SizedBox(width: 8),
                              ShaderMask(
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
                                    fontSize: 16 * fontScale,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/homepage_images/softwaricaa.png',
                                height: 28 * fontScale,
                                width: 28 * fontScale,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Softwarica College, Dillibazar, Kathmandu',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5 * fontScale,
                                    color: Colors.black87,
                                  ),
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
      duration: const Duration(seconds: 8),
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
                Colors.deepOrange.withOpacity(0.18 + 0.12 * _animation.value),
                Colors.white,
                const Color(0xFF1976D2).withOpacity(0.10 + 0.10 * (1 - _animation.value)),
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: cardWidth,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isActive ? Colors.deepOrange.withOpacity(0.18) : Colors.black12,
              blurRadius: isActive ? 32 : 12,
              offset: const Offset(0, 8),
            ),
          ],
          border: isActive
              ? Border.all(color: Colors.deepOrange, width: 2.5)
              : Border.all(color: Colors.transparent, width: 1),
          backgroundBlendMode: BlendMode.overlay,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    slide.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                slide.title,
                style: TextStyle(
                  fontSize: 19 * fontScale,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                slide.subtitle,
                style: TextStyle(
                  fontSize: 13.5 * fontScale,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  slide.description,
                  style: TextStyle(fontSize: 12.5 * fontScale, color: Colors.black87),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              ...slide.details,
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
  const _Badge({Key? key, required this.text, required this.color, required this.fontScale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18 * fontScale, vertical: 7 * fontScale),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.5 * fontScale,
              color: color,
              letterSpacing: 1.1,
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
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepOrange, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
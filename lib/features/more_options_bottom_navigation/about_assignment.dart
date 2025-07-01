import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutAssignmentPage extends StatefulWidget {
  const AboutAssignmentPage({Key? key}) : super(key: key);

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
      description:
          'Follow us or drop your any query related to Mitho-Bites at:',
      details: [
        _DetailRow(icon: Icons.email, text: 'aadarsha@gmail.com'),
        _DetailRow(icon: Icons.phone, text: '9864530000'),
      ],
      footer: 'Student',
    ),
    _AboutSlide(
      image: 'assets/homepage_images/sir.png',
      title: 'Kiran Rana',
      subtitle: 'HOD, BSc (Hons) Computing',
      description: 'Module supervisor for the development of Mitho Bites.',
      details: [_DetailRow(icon: FontAwesomeIcons.userTie, text: 'Supervisor')],
      footer: 'Faculty',
    ),
    _AboutSlide(
      image: 'assets/homepage_images/softwaricaa.png',
      title: 'Softwarica College ',
      subtitle: 'Dillibazar, Kathmandu',
      description:
          'An institution fostering innovation and excellence in IT education.',
      details: [_DetailRow(icon: FontAwesomeIcons.school, text: 'Institution')],
      footer: 'College',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double sliderHeight = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFE0B2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
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
                      return _AnimatedSlide(slide: slide);
                    },
                  ),
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
                          width: _currentPage == index ? 24 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
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
            const SizedBox(height: 32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _slides[_currentPage].footer,
                key: ValueKey(_slides[_currentPage].footer),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.deepOrange),
                  const SizedBox(width: 8),
                  const Text(
                    'Mitho Bites Assignment 2025',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSlide extends StatelessWidget {
  final _AboutSlide slide;
  const _AnimatedSlide({required this.slide});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              slide.image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            slide.subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              slide.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          ...slide.details,
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
  final String footer;

  _AboutSlide({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.details,
    required this.footer,
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
          Icon(icon, color: Colors.deepOrange, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

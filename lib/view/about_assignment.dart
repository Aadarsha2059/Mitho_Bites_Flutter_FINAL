// Make sure to add font_awesome_flutter to your pubspec.yaml:
// dependencies:
//   font_awesome_flutter: ^10.7.0
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
          'Developer of Mitho Bites.\nContact: aadarsha@gmail.com\nPhone: 9864530000',
      label: 'Developer',
      icon: Icons.person,
      color: Colors.deepOrange,
    ),
    _AboutSlide(
      image: 'assets/homepage_images/sir.png',
      title: 'Kiran Rana',
      subtitle: 'HOD, BSc (Hons) Computing',
      description: 'Module supervisor for the development of Mitho Bites.',
      label: 'Supervisor',
      icon: FontAwesomeIcons.userTie,
      color: Colors.blue,
    ),
    _AboutSlide(
      image: 'assets/homepage_images/softwaricaa.png',
      title: 'Softwarica College of IT & E-Commerce',
      subtitle: 'Dillibazar, Kathmandu',
      description: 'Institution fostering innovation and excellence in IT education.',
      label: 'Institution',
      icon: FontAwesomeIcons.school,
      color: Colors.green,
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
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double sliderHeight = screenHeight * 0.38;
    final double imageHeight = sliderHeight * 0.85;
    final double cardWidth = screenWidth * 0.88;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Assignment'),
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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: sliderHeight,
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Center(
                      child: Container(
                        width: cardWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withOpacity(0.10),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            slide.image,
                            width: cardWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.deepOrange
                          : Colors.deepOrange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios, size: 16),
                        SizedBox(width: 4),
                        Text('Previous'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _currentPage < _slides.length - 1
                        ? () => _goToPage(_currentPage + 1)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Text('Next'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _SlideInfoCard(slide: _slides[_currentPage]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    const Text(
                      'Mitho Bites Assignment 2024',
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
      ),
    );
  }
}

class _SlideInfoCard extends StatelessWidget {
  final _AboutSlide slide;
  const _SlideInfoCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(slide.icon, color: slide.color, size: 22),
                const SizedBox(width: 8),
                Text(
                  slide.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: slide.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              slide.subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              slide.description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: slide.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                slide.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: slide.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutSlide {
  final String image;
  final String title;
  final String subtitle;
  final String description;
  final String label;
  final IconData icon;
  final Color color;

  _AboutSlide({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.label,
    required this.icon,
    required this.color,
  });
} 
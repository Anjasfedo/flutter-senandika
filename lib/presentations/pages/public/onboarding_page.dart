import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pulih/constants/route_constant.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A5ACD), // Medium purple
              Color(0xFF4B0082), // Indigo
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // PageView for the onboarding screens
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Page 1
                    _buildOnboardingPage(
                      imagePlaceholder: 'assets/images/onboarding1.png',
                      title: 'Kesehatan Mental Itu Penting!',
                      subtitle:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      showButton: false, // No button
                    ),
                    // Page 2
                    _buildOnboardingPage(
                      imagePlaceholder: 'assets/images/onboarding2.png',
                      title: 'Temukan Dukunganmu',
                      subtitle:
                          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      showButton: false, // No button
                    ),
                    // Page 3 (Final)
                    _buildOnboardingPage(
                      imagePlaceholder: 'assets/images/onboarding3.png',
                      title: 'Mulai Konseling Bersama Pulih',
                      subtitle:
                          'Temukan dukungan yang tepat untuk kesehatan mental Anda bersama konselor profesional.',
                      showButton: true, // SHOW button
                    ),
                  ],
                ),
              ),

              // Page indicators
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 10,
                      width: _currentPage == index ? 25 : 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Unified Builder
  Widget _buildOnboardingPage({
    required String imagePlaceholder,
    required String title,
    required String subtitle,
    required bool showButton, // Changed to a boolean flag
  }) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. Image
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 100, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),

          // 2. Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // 3. Subtitle (Description)
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),

          // 4. Button Space Logic
          // We ALWAYS add the spacing and a container of height 50.
          // If showButton is true -> We put the button in that container.
          // If showButton is false -> The container is empty but takes up the same space.
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50, // FIXED HEIGHT for consistency
            child: showButton
                ? ElevatedButton(
                    onPressed: () {
                      Get.toNamed(RouteConstants.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox(), // Empty box acts as a placeholder
          ),
        ],
      ),
    );
  }
}

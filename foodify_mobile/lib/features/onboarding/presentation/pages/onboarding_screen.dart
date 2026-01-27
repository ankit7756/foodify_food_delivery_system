import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../auth/presentation/pages/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  Future<void> _navigateToLogin() async {
    await StorageService.saveString('has_seen_onboarding', 'true');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dots(int i) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: _index == i ? 30 : 10,
      decoration: BoxDecoration(
        gradient: _index == i
            ? const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
              )
            : null,
        color: _index == i ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: _index == i
            ? [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPage(
        icon: Icons.restaurant_menu,
        iconColor: const Color(0xFFFF6B35),
        backgroundColor: const Color(0xFFFFF5F0),
        title: "Find Delicious Food",
        subtitle:
            "Explore restaurants near you and order your favorite dishes in seconds.",
      ),
      _OnboardingPage(
        icon: Icons.delivery_dining,
        iconColor: const Color(0xFF4CAF50),
        backgroundColor: const Color(0xFFF1F8E9),
        title: "Fast Delivery",
        subtitle:
            "Get your food delivered hot and fresh with real-time tracking.",
      ),
      _OnboardingPage(
        icon: Icons.payment,
        iconColor: const Color(0xFF2196F3),
        backgroundColor: const Color(0xFFE3F2FD),
        title: "Secure Payment",
        subtitle: "Multiple payment options with secure checkout.",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _navigateToLogin,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: pages,
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) => _dots(i)),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: const Color(0xFFFF6B35).withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (_index == pages.length - 1) {
                      _navigateToLogin();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _index == pages.length - 1 ? "Get Started" : "Next",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Onboarding Page Widget
class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 100, color: iconColor),
          ),

          const SizedBox(height: 50),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

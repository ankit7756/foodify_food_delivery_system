// import 'package:flutter/material.dart';
// import '../widgets/onboarding_page.dart';
// import '../../../../app/theme/app_colors.dart';
// import 'login_screen.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _index = 0;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Widget _dots(int i) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       height: 8,
//       width: _index == i ? 22 : 8,
//       decoration: BoxDecoration(
//         color: _index == i ? AppColors.primary : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       const OnboardingPage(
//         image: "assets/images/foodify_logo.png",
//         title: "Find Delicious Food",
//         subtitle:
//             "Explore restaurants near you and order your favorite dishes in seconds.",
//       ),
//       const OnboardingPage(
//         image: "assets/images/foodify_logo.png",
//         title: "Fast Delivery",
//         subtitle:
//             "Get your food delivered hot and fresh with real-time tracking.",
//       ),
//       const OnboardingPage(
//         image: "assets/images/foodify_logo.png",
//         title: "Secure Payment",
//         subtitle: "Multiple payment options with secure checkout.",
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const LoginScreen()),
//                   );
//                 },
//                 child: const Text("Skip"),
//               ),
//             ),
//             Expanded(
//               child: PageView(
//                 controller: _controller,
//                 onPageChanged: (i) => setState(() => _index = i),
//                 children: pages,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(pages.length, (i) => _dots(i)),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary, // same background color
//                   minimumSize: const Size.fromHeight(52),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   shadowColor: Colors.black.withOpacity(0.15),
//                   elevation: 4,
//                 ),
//                 onPressed: () {
//                   if (_index == pages.length - 1) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()),
//                     );
//                   } else {
//                     _controller.nextPage(
//                       duration: const Duration(milliseconds: 350),
//                       curve: Curves.easeInOut,
//                     );
//                   }
//                 },
//                 child: Text(
//                   _index == pages.length - 1 ? "Get Started" : "Next",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/storage/storage_service.dart'; // ADD THIS
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  // ADD THIS METHOD
  Future<void> _navigateToLogin() async {
    // Mark onboarding as seen
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
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 8,
      width: _index == i ? 22 : 8,
      decoration: BoxDecoration(
        color: _index == i ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OnboardingPage(
        image: "assets/images/foodify_logo.png",
        title: "Find Delicious Food",
        subtitle:
            "Explore restaurants near you and order your favorite dishes in seconds.",
      ),
      const OnboardingPage(
        image: "assets/images/foodify_logo.png",
        title: "Fast Delivery",
        subtitle:
            "Get your food delivered hot and fresh with real-time tracking.",
      ),
      const OnboardingPage(
        image: "assets/images/foodify_logo.png",
        title: "Secure Payment",
        subtitle: "Multiple payment options with secure checkout.",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToLogin, // UPDATED
                child: const Text("Skip"),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: pages,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (i) => _dots(i)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.black.withOpacity(0.15),
                  elevation: 4,
                ),
                onPressed: () {
                  if (_index == pages.length - 1) {
                    _navigateToLogin(); // UPDATED
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
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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

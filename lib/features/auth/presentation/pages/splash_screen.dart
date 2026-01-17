// import 'package:flutter/material.dart';
// import '../../../../app/theme/app_colors.dart';
// import 'onboarding_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _anim;
//   late final Animation<double> _scale;

//   @override
//   void initState() {
//     super.initState();
//     _anim = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _scale = Tween<double>(
//       begin: 0.75,
//       end: 1.05,
//     ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));
//     _anim.forward();
//     Future.delayed(const Duration(seconds: 4), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _anim.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.primary, AppColors.primaryDark],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ScaleTransition(
//                 scale: _scale,
//                 child: Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 18,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Image.asset(
//                     'assets/images/foodify_logo.png',
//                     width: 110,
//                     height: 110,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Foodify",
//                 style: TextStyle(
//                   fontSize: 28,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Delicious food delivered to you",
//                 style: TextStyle(color: Colors.white70),
//               ),
//               const SizedBox(height: 28),
//               Container(
//                 width: 80,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   color: Colors.white24,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: FractionallySizedBox(
//                   alignment: Alignment.centerLeft,
//                   widthFactor: 0.55,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/storage/user_session_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../features/dashboard/presentation/pages/dashboard_screen.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(
      begin: 0.75,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));
    _anim.forward();

    // Check user session after animation
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    // Wait for splash animation (4 seconds as you had)
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Check if user has a token (logged in)
    final token = UserSessionService.getToken();

    if (token != null && token.isNotEmpty) {
      // User is logged in - go directly to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // User is not logged in - check if onboarding was shown
      final hasSeenOnboarding = StorageService.getString('has_seen_onboarding');

      if (hasSeenOnboarding == 'true') {
        // Skip onboarding - go directly to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        // First time - show Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/foodify_logo.png',
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Foodify",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Delicious food delivered to you",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 28),
              Container(
                width: 80,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.55,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

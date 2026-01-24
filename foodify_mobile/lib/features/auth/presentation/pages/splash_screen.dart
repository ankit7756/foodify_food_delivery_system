import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/storage/user_session_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../features/dashboard/presentation/pages/dashboard_screen.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final AnimationController _slideController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for logo
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Fade animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Slide animation for tagline
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Progress animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startAnimations();
    _checkUserSession();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
  }

  Future<void> _checkUserSession() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final token = UserSessionService.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      final hasSeenOnboarding = StorageService.getString('has_seen_onboarding');

      if (hasSeenOnboarding == null || hasSeenOnboarding != 'true') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B35), // Vibrant orange
              const Color(0xFFFF8E53), // Light orange
              const Color(0xFFFFA07A), // Peach
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: -100,
              right: -100,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Animated Logo Container
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                            blurRadius: 50,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom Food Icon
                          Icon(
                            Icons.restaurant_menu,
                            size: 80,
                            color: const Color(0xFFFF6B35),
                          ),
                          // Small decorative dots
                          Positioned(
                            top: 30,
                            right: 35,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA07A),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 40,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8E53),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App Name with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.95)],
                      ).createShader(bounds),
                      child: const Text(
                        "Foodify",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline with slide animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "Delicious food, delivered fast",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Animated progress indicator
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            "Loading your experience...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 200,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

/// ──────────────────────────────────────────────
/// Splash Screen
/// ──────────────────────────────────────────────
///
/// Animated splash screen that:
///   1. Shows the app logo with a fade + scale animation
///   2. Displays the app name with a slide-in effect
///   3. Auto-navigates after 2.5s to either:
///      - OnboardingScreen (first launch)
///      - HomeScreen (returning user)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  /// Wait for the splash animation, then navigate.
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(AppDurations.splash);

    if (!mounted) return;

    final onboardingProvider = Provider.of<OnboardingProvider>(
      context,
      listen: false,
    );

    // Navigate to onboarding or home based on saved state
    final destination = onboardingProvider.isComplete
        ? const HomeScreen()
        : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── App Icon ──
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 56,
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 24),

            // ── App Name ──
            Text(
              'TaskFlow',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 300),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 8),

            // ── Tagline ──
            Text(
              'Organize. Focus. Achieve.',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 60),

            // ── Loading Indicator ──
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.6),
                ),
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 1000),
                ),
          ],
        ),
      ),
    );
  }
}

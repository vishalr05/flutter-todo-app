import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/onboarding_provider.dart';
import '../utils/constants.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

/// ──────────────────────────────────────────────
/// Onboarding Screen
/// ──────────────────────────────────────────────
///
/// A beautiful welcome screen shown on first launch with:
///   - Soft gradient background
///   - Custom illustration (built with Flutter widgets)
///   - App title and motivational subtitle
///   - "Get Started" gradient button
///   - Smooth fade/slide animations
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.softGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Illustration ──
                _buildIllustration(size),

                const Spacer(flex: 1),

                // ── Title ──
                Text(
                  'TaskFlow',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 400),
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 400),
                    ),

                const SizedBox(height: 12),

                // ── Subtitle ──
                Text(
                  'Your tasks, organized beautifully.\nSimple, focused, and delightful.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
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
                    ),

                const Spacer(flex: 2),

                // ── Get Started Button ──
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: 'Get Started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => _onGetStarted(context),
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 800),
                    )
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handle "Get Started" button press
  void _onGetStarted(BuildContext context) {
    // Mark onboarding as complete
    Provider.of<OnboardingProvider>(context, listen: false)
        .completeOnboarding();

    // Navigate to Home Screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Build the onboarding illustration with Flutter widgets
  Widget _buildIllustration(Size screenSize) {
    final illustrationSize = screenSize.width * 0.65;

    return SizedBox(
      width: illustrationSize,
      height: illustrationSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Large background circle
          Container(
            width: illustrationSize,
            height: illustrationSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.lavender.withValues(alpha: 0.08),
                  AppColors.coral.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),

          // Middle circle
          Container(
            width: illustrationSize * 0.7,
            height: illustrationSize * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.lavender.withValues(alpha: 0.12),
                  AppColors.coral.withValues(alpha: 0.12),
                ],
              ),
            ),
          ),

          // Central clipboard card
          Container(
            width: illustrationSize * 0.45,
            height: illustrationSize * 0.55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lavender.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMiniTaskRow(true),
                const SizedBox(height: 10),
                _buildMiniTaskRow(true),
                const SizedBox(height: 10),
                _buildMiniTaskRow(false),
                const SizedBox(height: 10),
                _buildMiniTaskRow(false),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 800))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
              ),

          // Floating checkmark badge (top-right)
          Positioned(
            top: illustrationSize * 0.1,
            right: illustrationSize * 0.1,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lavender.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: 0,
                  end: -8,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                ),
          ),

          // Floating star badge (bottom-left)
          Positioned(
            bottom: illustrationSize * 0.12,
            left: illustrationSize * 0.08,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.coral,
                size: 22,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: 0,
                  end: 6,
                  duration: const Duration(milliseconds: 2200),
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }

  /// Mini task row for the clipboard illustration
  Widget _buildMiniTaskRow(bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isChecked ? AppColors.lavender : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isChecked ? AppColors.lavender : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: isChecked
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: isChecked ? Colors.grey.shade200 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

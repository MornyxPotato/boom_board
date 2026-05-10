import 'package:boom_board/core/domain/constants/home_animation_constant.dart';
import 'package:boom_board/core/domain/entities/enums/home_animation_state.dart';
import 'package:boom_board/core/presentation/controllers/home_controller.dart';
import 'package:boom_board/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBackgroundAnim extends StatelessWidget {
  const HomeBackgroundAnim({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: HomeIds.backgroundId,
      builder: (ctl) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // --- STATE CHECKS ---
            final isVisible = ctl.currentState != HomeAnimationState.resetting;
            final isSpawning = ctl.currentState == HomeAnimationState.spawning;
            final isExploding = ctl.currentState == HomeAnimationState.exploding;
            final isCelebrating = ctl.currentState == HomeAnimationState.celebrating;

            // --- WINNER LOGIC ---
            final localWins = ctl.currentAttackType == AttackType.arcThrow;
            final otherWins = ctl.currentAttackType == AttackType.verticalDrop;

            // --- OPACITY MATH ---
            double localOpacity = 0.0;
            double otherOpacity = 0.0;

            if (isVisible) {
              if (isSpawning) {
                localOpacity = 1.0;
                otherOpacity = 1.0;
              } else if (isCelebrating) {
                // Winner appears at 100%, loser fades to 0%
                localOpacity = localWins ? 1.0 : 0.0;
                otherOpacity = otherWins ? 1.0 : 0.0;
              } else if (isExploding) {
                // Both players are completely hidden during the BOOM!
                if (otherWins) {
                  localOpacity = 0.0;
                } else if (localWins) {
                  localOpacity = 1.0;
                }
              } else {
                // During stealth, attack, and explosion:
                localOpacity = 0.5; // Local is sneaking
                otherOpacity = 0.0; // Other is hiding
              }
            }

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // --- 1. OTHER PLAYER (The Target) ---
                AnimatedPositioned(
                  duration: HomeAnimationConstant.reset,
                  curve: Curves.easeInOut,
                  left: ctl.otherX * w,
                  // Use the exact same Bounding Box Math for the other player!
                  top: (ctl.otherY * h) - 64,
                  child: SizedBox(
                    width: 64,
                    height: 128,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedOpacity(
                        duration: HomeAnimationConstant.fade,
                        opacity: otherOpacity,
                        child: (isCelebrating && otherWins)
                            // If they won the drop attack, show red victory!
                            ? const $AssetsImagesGen().playerRedWin.image(width: 64, height: 128, fit: BoxFit.fitWidth)
                            : const $AssetsImagesGen().robotRed.image(width: 64, height: 64, fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                ),

                // --- 2. LOCAL PLAYER (The Attacker) ---
                AnimatedPositioned(
                  duration: HomeAnimationConstant.walk, // Slow stealthy walk
                  curve: Curves.easeInOut,
                  left: ctl.localX * w,
                  top: (ctl.localY * h) - 64,
                  child: SizedBox(
                    width: 64,
                    height: 128,
                    child: Align(
                      alignment: Alignment.bottomCenter, // Pin all sprites to the floor of this box
                      child: AnimatedOpacity(
                        duration: isExploding && otherWins ? Duration.zero : HomeAnimationConstant.fade,
                        opacity: localOpacity,
                        child: (isCelebrating && localWins)
                            // Show victory sprite/icon during celebration!
                            ? const $AssetsImagesGen().playerBlueWin.image(width: 64, height: 128, fit: BoxFit.fitWidth)
                            : const $AssetsImagesGen().robotBlue.image(width: 64, height: 64, fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                ),

                // --- 3. THE BOMB / ATTACK ---
                if (ctl.currentState == HomeAnimationState.attacking) _buildAttackAnimation(ctl, w, h),

                // --- 4. THE EXPLOSION ---
                if (ctl.currentState == HomeAnimationState.exploding)
                  Positioned(
                    left: (ctl.currentAttackType == AttackType.arcThrow ? ctl.otherX : ctl.localX) * w,
                    top: (ctl.currentAttackType == AttackType.arcThrow ? ctl.otherY : ctl.localY) * h,
                    // Use the SpriteAnimation widget we built earlier!
                    child: const $AssetsImagesGen().explosion.image(width: 64, height: 64, fit: BoxFit.fitWidth),
                  ),

                // --- 5. THE FLOATING SKULL ---
                // Keep it in the tree during both the explosion and the celebration!
                if (ctl.currentState == HomeAnimationState.exploding ||
                    ctl.currentState == HomeAnimationState.celebrating)
                  _buildDeathAnimation(ctl, w, h),
              ],
            );
          },
        );
      },
    );
  }

  // --- HELPER: BOMB ANIMATION ---
  Widget _buildAttackAnimation(HomeController ctl, double w, double h) {
    if (ctl.currentAttackType == AttackType.arcThrow) {
      // Horizontal throw from Local to Other
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        duration: HomeAnimationConstant.bombFlight, // Matches controller timer!
        builder: (context, progress, child) {
          final currentX = ctl.localX + ((ctl.otherX - ctl.localX) * progress);
          final currentY = ctl.localY + ((ctl.otherY - ctl.localY) * progress);
          return Positioned(
            left: currentX * w,
            top: currentY * h,
            child: const $AssetsImagesGen().bomb.image(width: 64, height: 64, fit: BoxFit.fitWidth),
          );
        },
      );
    } else {
      // Vertical drop onto Local
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: -0.2, end: ctl.localY), // Starts above screen (-20%)
        duration: HomeAnimationConstant.bombFlight,
        curve: Curves.easeInQuint, // Starts slow, falls fast
        builder: (context, currentY, child) {
          return Positioned(
            left: ctl.localX * w,
            top: currentY * h,
            child: const $AssetsImagesGen().bomb.image(width: 64, height: 64, fit: BoxFit.fitWidth),
          );
        },
      );
    }
  }

  // --- HELPER: DEATH ANIMATION ---
  Widget _buildDeathAnimation(HomeController ctl, double w, double h) {
    // 1. Figure out who blew up
    final localWins = ctl.currentAttackType == AttackType.arcThrow;
    final loserX = localWins ? ctl.otherX : ctl.localX;
    final loserY = localWins ? ctl.otherY : ctl.localY;

    return TweenAnimationBuilder<double>(
      // Alternating attack types gives us a perfect unique key to restart the animation!
      key: ValueKey('death_${ctl.currentAttackType}'),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: HomeAnimationConstant.deathFloat, // Floats for 1.5 seconds
      curve: Curves.easeOut, // Starts moving fast, then smoothly slows down
      builder: (context, progress, child) {
        // Math: Keep opacity at 100% for the first 20% of the animation, then fade to 0%
        final opacity = progress < 0.2 ? 1.0 : 1.0 - ((progress - 0.2) / 0.8);

        // Math: Float upwards by exactly 120 pixels over the duration
        final currentY = (loserY * h) - (120 * progress);

        return Positioned(
          left: loserX * w,
          top: currentY,
          child: Opacity(
            opacity: opacity,
            // You can swap this Icon out for a skull Sprite image if you have one!
            child: const $AssetsImagesGen().deadIcon.image(width: 64, height: 64, fit: BoxFit.fitWidth),
          ),
        );
      },
    );
  }
}

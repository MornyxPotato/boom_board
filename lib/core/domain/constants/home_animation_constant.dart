abstract class HomeAnimationConstant {
  static const Duration spawn = Duration(milliseconds: 1500);
  static const Duration betweenLoopDelay = Duration(milliseconds: 2000);

  // Reposition Phase
  static const Duration walk = Duration(milliseconds: 2000);
  static const Duration fade = Duration(milliseconds: 800);

  // Attack & Explosion Phase
  static const Duration bombFlight = Duration(milliseconds: 1200);
  static const Duration explosion = Duration(milliseconds: 500);
  static const Duration deathFloat = Duration(milliseconds: 1500);

  // Resolution Phase
  static const Duration celebrate = Duration(milliseconds: 2500);
  static const Duration reset = Duration(milliseconds: 1000);
}

enum HomeAnimationState {
  spawning, // 1. Players fade in at edges
  repositioning, // 2. Local walks & fades to 50%, Other fades to 0%
  waiting, // 2.5 small delay before attacking
  attacking, // 3. Bomb is in the air (Arc or Vertical)
  exploding, // 4. BOOM! + Death sprite
  celebrating, // 5. Winner flexes
  resetting, // 6. Everything fades out before the next loop
}

enum AttackType { arcThrow, verticalDrop }

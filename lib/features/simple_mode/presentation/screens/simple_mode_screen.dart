import 'dart:math' as math;

import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/presentation/widgets/retro_dialog.dart';
import 'package:boom_board/core/presentation/widgets/retro_loading_text.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/log_action_type.dart';
import 'package:boom_board/features/simple_mode/domain/constants/animation_constant.dart' as anim_constant;
import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/animation/active_bomb_drop_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/animation/active_hide_animation_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/animation/active_tile_animation_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';
import 'package:boom_board/features/simple_mode/presentation/controllers/simple_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SimpleModeScreen extends GetView<SimpleModeController> {
  const SimpleModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: retroBackground,
      body: Row(
        children: [
          // ==========================================
          // LEFT PANE: THE DASHBOARD (30% Width)
          // ==========================================
          Container(
            width: Get.width * 0.3,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.white, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- HEADER (Leave room & Room Code) ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      RetroButton(
                        text: 'X',
                        color: retroRed,
                        onPressed: () {
                          Get.dialog(
                            RetroDialog(
                              title: 'Leave the room?',
                              message: 'Are you sure you want to disconnect and leave the room?',
                              onCancel: () => Get.back(),
                              onConfirm: () {
                                Get.back();
                                controller.leaveRoom();
                                Get.back();
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RetroButton(
                          text: 'Code\n${controller.roomCode}',
                          color: retroCyan,
                          onPressed: () async {
                            // Copy to clipboard
                            await Clipboard.setData(ClipboardData(text: controller.roomCode));

                            // Show a quick retro snackbar feedback
                            Get.snackbar(
                              'Copied!',
                              'Room code copied to clipboard.',
                              backgroundColor: retroGreen,
                              colorText: Colors.black,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 2),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // --- PHASE BANNER ---
                Container(
                  color: retroGrey,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GetBuilder<SimpleModeController>(
                    id: SimpleModeIds.controlPanel,
                    builder: (ctl) {
                      return Column(
                        children: [
                          if (ctl.currentState != GameState.lobby &&
                              ctl.currentState != GameState.end &&
                              ctl.currentState != GameState.process)
                            Text(
                              ctl.getPhaseText(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          if (ctl.currentState == GameState.process)
                            Center(
                              child: RetroLoadingText(
                                text: 'Loading',
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          // LOBBY CONTROLS (Start Game)
                          if (ctl.currentState == GameState.lobby) ...[
                            if (ctl.isHost)
                              RetroButton(
                                text: ctl.playerList.length > 1 ? 'Start game' : 'Need players',
                                color: retroGreen,
                                onPressed: ctl.playerList.length > 1 ? controller.startGame : null,
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: const RetroLoadingText(
                                  text: 'Waiting for host',
                                  color: retroYellow,
                                  fontSize: 20,
                                ),
                              ),
                            if (ctl.isHost) const SizedBox(height: 4),
                          ],

                          // ENDGAME CONTROLS (Play Again)
                          if (ctl.currentState == GameState.end) ...[
                            if (ctl.isHost)
                              RetroButton(
                                text: 'Play again',
                                color: retroGreen,
                                onPressed: controller.backToLobby,
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: const RetroLoadingText(
                                  text: 'Waiting for host',
                                  color: retroYellow,
                                  fontSize: 20,
                                ),
                              ),
                            if (ctl.isHost) const SizedBox(height: 4),
                            const SizedBox(height: 8),
                            RetroButton(
                              text: ctl.showEndgameOverlay ? 'HIDE RESULTS' : 'SHOW RESULTS',
                              color: retroBackground, // Makes it look like an outlined secondary button
                              onPressed: controller.toggleEndgameOverlay,
                              textColor: retroLightGrey,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ],
                      );
                    },
                  ),
                ),

                // --- PLAYER ROSTER ---
                Expanded(
                  flex: 3,
                  child: GetBuilder<SimpleModeController>(
                    id: SimpleModeIds.playerListPanel,
                    builder: (ctl) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: ctl.playerList.length,
                        itemBuilder: (context, index) {
                          final player = ctl.playerList[index];

                          // Dead players get a dark red background, alive players get black
                          final backgroundColor = player.isAlive ? Colors.black : retroRed.withAlpha(51);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                color: player.id == controller.hostId ? retroYellow : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Player Name
                                Expanded(
                                  child: Text(
                                    player.name,
                                    style: TextStyle(
                                      // Dim the text if they are dead or disconnected
                                      color: (player.isAlive && !player.isDisconnected) ? Colors.white : Colors.grey,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // The Dynamic Status Icon
                                _buildPlayerStatusIcon(player, ctl.currentState),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // --- ACTION LOG (Terminal) ---
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      border: Border(top: BorderSide(color: Colors.white, width: 4)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: GetBuilder<SimpleModeController>(
                      id: SimpleModeIds.actionLogPanel,
                      builder: (ctl) {
                        return ListView.builder(
                          controller: ctl.logScrollController,
                          itemCount: ctl.actionLogList.length,
                          itemBuilder: (context, index) {
                            return _buildLogEntry(ctl.actionLogList[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // RIGHT PANE: THE ARENA (70% Width)
          // ==========================================
          Expanded(
            child: Center(
              child: _buildBoardArea(),
            ),
          ),
        ],
      ),
    );
  }

  // --- THE 8x8 BOARD BUILDER ---
  Widget _buildBoardArea() {
    const columns = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    const rows = ['1', '2', '3', '4', '5', '6', '7', '8'];
    const double tileSize = 60.0; // Size of each grid square

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Coordinates (A-H)
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: tileSize), // Corner spacer
              ...columns.map(
                (c) => SizedBox(
                  width: tileSize,
                  child: Center(
                    child: Text(c, style: const TextStyle(color: Colors.grey, fontSize: 24)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // The Middle Section (Numbers + Board)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left Coordinates (1-8)
            Column(
              children: rows
                  .map(
                    (r) => SizedBox(
                      height: tileSize,
                      width: tileSize,
                      child: Center(
                        child: Text(r, style: const TextStyle(color: Colors.grey, fontSize: 24)),
                      ),
                    ),
                  )
                  .toList(),
            ),

            // THE ACTUAL GRID
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
              ),
              child: SizedBox(
                width: tileSize * 8,
                height: tileSize * 8,
                child: GetBuilder<SimpleModeController>(
                  id: SimpleModeIds.boardPanel,
                  builder: (ctl) {
                    final localPlayer = ctl.localPlayer;
                    final isPositionPhase = ctl.currentState == GameState.position;
                    final isAttackPhase = ctl.currentState == GameState.attack;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // THE FLOOR / THE BOARD
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                          ),
                          itemCount: 64,
                          itemBuilder: (context, index) {
                            final x = index % 8;
                            final y = index ~/ 8;
                            final isDark = (x + y) % 2 == 1;

                            // Check tile states
                            final isDestroyed = ctl.destroyedTile.any((t) => t.x == x && t.y == y);
                            final isHovered = ctl.hoveredTile?.x == x && ctl.hoveredTile?.y == y;

                            final isLockedTarget = ctl.lockedBombTarget?.x == x && ctl.lockedBombTarget?.y == y;

                            // Check if the local player is allowed to interact with this tile right now
                            bool canInteract = false;
                            if (!isDestroyed && localPlayer != null && localPlayer.isAlive) {
                              if (isPositionPhase && !localPlayer.hasPositioned) canInteract = true;
                              if (isAttackPhase && !localPlayer.hasThrowBomb) canInteract = true;
                            }

                            // Determine the cursor
                            SystemMouseCursor cursor = SystemMouseCursors.basic;
                            if (isDestroyed) {
                              cursor = SystemMouseCursors.forbidden; // Red circle with a slash
                            } else if (canInteract) {
                              cursor = SystemMouseCursors.click; // Pointing finger
                            }

                            return MouseRegion(
                              cursor: cursor,
                              onEnter: (_) {
                                if (canInteract) ctl.setHoveredTile(Coordinate(x: x, y: y));
                              },
                              onExit: (_) {
                                if (canInteract) ctl.setHoveredTile(null);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  if (!canInteract) return;
                                  if (isPositionPhase) ctl.setPosition(x, y);
                                  if (isAttackPhase) ctl.throwBomb(x, y);
                                },
                                child: Container(
                                  color: isDark ? retroGrey : retroGridLight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // --- DESTROYED TILE EFFECT (Laser fire) ---
                                      if (isDestroyed)
                                        Container(
                                          color: Colors.orange.withAlpha(
                                            128,
                                          ), // TODO replace this with fire animation gif
                                          child: const Center(
                                            child: Icon(Icons.local_fire_department, color: retroRed, size: 32),
                                          ),
                                        ),

                                      // --- LOCKED TARGET EFFECT ---
                                      if (isLockedTarget)
                                        const Opacity(
                                          opacity: 0.5,
                                          child: Icon(
                                            Icons.gps_fixed,
                                            color: retroRed,
                                            size: 40,
                                          ),
                                        ),

                                      // --- HOVER EFFECTS ---
                                      if (isHovered && canInteract)
                                        if (isPositionPhase)
                                          // Ghost Character (position Phase)
                                          const Icon(
                                            Icons.android, // TODO replace this with player character
                                            color: retroCyan,
                                            size: 40,
                                          )
                                        else if (isAttackPhase)
                                          // Target reticle (Bomb Phase)
                                          const Icon(
                                            Icons.gps_fixed, // Target reticle icon
                                            color: retroRed,
                                            size: 40,
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // THE ANIMATION CANVAS
                        SizedBox(
                          width: tileSize * 8,
                          height: tileSize * 8,
                          // IgnorePointer ensures clicks pass through the animations to the grid below
                          child: IgnorePointer(
                            child: Stack(
                              clipBehavior: Clip.none, // Allows bombs to start outside the box
                              children: [
                                // Static Local Player (Appears after their animation finishes)
                                _buildStaticLocalPlayer(ctl, tileSize),

                                // Stealth Hide Sequences (Local & Enemies)
                                ...ctl.activeHideAnimations.map(
                                  (anim) => _buildHideSequence(anim, tileSize),
                                ),

                                // Orbital Lasers (ADD THIS HERE)
                                ...ctl.activeLasers.map(
                                  (anim) => _buildLaserAnimation(anim, tileSize),
                                ),

                                // Bombs falling/arcing
                                ...ctl.activeBombDrops.map(
                                  (drop) => _buildBombAnimation(drop, tileSize, ctl.localPlayerId),
                                ),

                                // Explosions (Kaboom!)
                                ...ctl.activeExplosions.map(
                                  (anim) => _buildExplosionAnimation(anim, tileSize),
                                ),

                                // Ghosts floating away
                                ...ctl.activeDeaths.map(
                                  (anim) => _buildDeathAnimation(anim, tileSize),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // THE CEILING
                        // This will only show up when currentState == GameState.end
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                          child: _buildEndgameOverlay(ctl),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- PLAYER STATUS ICON LOGIC ---
  Widget _buildPlayerStatusIcon(SimpleModePlayerEntity player, GameState currentState) {
    // Highest Priority: Disconnected
    if (player.isDisconnected) {
      // TODO Replace this with disconnect icon
      return const Icon(Icons.power_off, color: Colors.grey, size: 24);
    }

    // Second Priority: Dead
    if (!player.isAlive) {
      // TODO Replace this with dead icon
      return const Icon(Icons.close, color: retroRed, size: 28);
    }

    // Alive & Active Phases
    if (currentState == GameState.position) {
      // TODO Replace this with ready / check mark icon
      return player.hasPositioned
          ? const Icon(Icons.check_box, color: retroGreen, size: 24)
          : const Icon(Icons.check_box_outline_blank, color: Colors.grey, size: 24);
    }

    if (currentState == GameState.attack) {
      if (player.hasThrowBomb) {
        int? throwOrder = player.throwOrder;
        if (throwOrder != null) throwOrder += 1;
        return Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: retroRed,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
          ),
          child: Text(
            '${throwOrder ?? '-'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        );
      } else {
        // TODO Replace this with ready / check mark icon
        return const Icon(Icons.gps_not_fixed, color: Colors.grey, size: 24);
      }
    }

    // Lobby, Process, or End phases (just show nothing if they are alive and fine)
    return const SizedBox(width: 24, height: 24);
  }

  // --- ACTION LOG FORMATTER ---
  Widget _buildLogEntry(ActionLogEntity log) {
    String prefix = '';
    Color prefixColor = Colors.white;
    List<InlineSpan> messageSpans = [];

    // Convert 0-7 coordinates to A-H and 1-8
    String getCoord(int x, int y) {
      final col = String.fromCharCode('A'.codeUnitAt(0) + x);
      final row = (y + 1).toString();
      return '$col$row';
    }

    // Helper to generate a colored TextSpan for coordinates
    TextSpan coordText(int x, int y) {
      return TextSpan(
        text: getCoord(x, y),
        style: const TextStyle(color: retroCyan),
      );
    }

    try {
      switch (log.type) {
        case LogActionType.bombExploded:
          final data = log.getLogBombExplodedData();
          prefix = '[BOMB]';
          prefixColor = retroYellow;
          messageSpans = [
            TextSpan(text: ' ${data.bomberName} struck '),
            coordText(data.x, data.y),
            const TextSpan(text: '.'),
          ];
          break;
        case LogActionType.playerEliminated:
          final data = log.getLogPlayerEliminatedData();
          prefix = '[KILL]';
          prefixColor = retroRed;
          messageSpans = [
            TextSpan(text: ' ${data.victimName} eliminated by ${data.bomberName}!'),
          ];
          break;
        case LogActionType.orbitalLaserFired:
          final data = log.getLogOrbitalLaserFiredData();
          prefix = '[LASER]';
          prefixColor = retroOrange;
          messageSpans = [
            const TextSpan(text: ' Orbital strike scorched '),
          ];
          // Loop through all destroyed tiles and add them with commas
          for (int i = 0; i < data.tiles.length; i++) {
            messageSpans.add(coordText(data.tiles[i].x, data.tiles[i].y));
            if (i < data.tiles.length - 1) {
              messageSpans.add(const TextSpan(text: ', '));
            }
          }
          messageSpans.add(const TextSpan(text: '.'));
          break;
        case LogActionType.playerDisconnected:
          final data = log.getLogPlayerDisconnectedData();
          prefix = '[DC]';
          prefixColor = Colors.grey;
          messageSpans = [
            TextSpan(text: ' ${data.playerName} lost connection.'),
          ];
          break;
      }
    } catch (e) {
      // Fallback just in case parsing fails
      prefix = '[SYS]';
      prefixColor = Colors.grey;
      messageSpans = [
        const TextSpan(text: ' Unknown event occurred.'),
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.white70),
          children: [
            const TextSpan(
              text: '> ',
              style: TextStyle(color: retroGreen),
            ),
            TextSpan(
              text: prefix,
              style: TextStyle(color: prefixColor),
            ),
            ...messageSpans, // Unpack the array of spans directly into the text!
          ],
        ),
      ),
    );
  }

  // --- ENDGAME SCOREBOARD OVERLAY ---
  Widget _buildEndgameOverlay(SimpleModeController ctl) {
    if (ctl.currentState != GameState.end || !ctl.showEndgameOverlay) {
      return const SizedBox.shrink();
    }

    return Container(
      // Constrain the height so it doesn't break on small screens
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.8, // Takes up a max of 80% of the screen height
        maxWidth: 600, // Prevents it from stretching too wide on massive monitors
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: retroBackground,
        border: Border.all(color: retroYellow, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(8, 8))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'GAME ENDED',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: retroYellow,
              fontSize: 32,
              shadows: [Shadow(color: Colors.black, offset: Offset(4, 4))],
            ),
          ),
          const SizedBox(height: 32),

          // 3. Make the player list scrollable!
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ctl.finalRanking.map((player) {
                  final isWinner = player.rank == 1;

                  // Color logic: Grey if DC, Green if Alive, Red if Dead
                  final textColor = player.isDisconnected ? Colors.grey : (player.isAlive ? retroGreen : retroRed);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#${player.rank} ',
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Flexible(
                          child: Text(
                            player.name,
                            style: TextStyle(color: textColor, fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // 4. Added the [DC] logic check
                        if (player.isDisconnected)
                          const Text(
                            ' [DC]',
                            style: TextStyle(color: Colors.grey, fontSize: 24),
                          )
                        else if (isWinner)
                          const Text(
                            ' [WINNER]',
                            style: TextStyle(color: retroYellow, fontSize: 24),
                          )
                        else if (!player.isAlive)
                          const Text(
                            ' [KIA]',
                            style: TextStyle(color: Colors.grey, fontSize: 24),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 32),
          RetroButton(
            text: 'Close',
            color: retroRed,
            onPressed: controller.toggleEndgameOverlay,
          ),
        ],
      ),
    );
  }

  // --- BOMB DROP & THROW ANIMATION ---
  Widget _buildBombAnimation(ActiveBombDropEntity drop, double tileSize, String localPlayerId) {
    final targetPixelX = drop.targetX * tileSize;
    final targetPixelY = drop.targetY * tileSize;

    final startPixelX = drop.startX * tileSize;
    final startPixelY = drop.startY * tileSize;

    final isLocalPlayer = drop.bomberId == localPlayerId;

    return TweenAnimationBuilder<double>(
      key: ValueKey(drop.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: anim_constant.bombDrop,
      // Use easeIn for gravity drops, but easeOut looks better for throws!
      curve: isLocalPlayer ? Curves.easeOutQuad : Curves.easeInCubic,
      builder: (context, progress, child) {
        double currentX;
        double currentY;

        if (isLocalPlayer || drop.startX != -1 || drop.startY != -1) {
          // --- ARC THROW MATH (Local Player) ---
          // 1. Calculate the straight line X and Y
          currentX = startPixelX + ((targetPixelX - startPixelX) * progress);
          double linearY = startPixelY + ((targetPixelY - startPixelY) * progress);

          // 2. Add the Arc!
          // math.sin creates a curve that peaks at 0.5 progress. We multiply by 100 pixels for height.
          final arcHeight = 100.0;
          currentY = linearY - (math.sin(progress * math.pi) * arcHeight);
        } else {
          // --- SKY DROP MATH (Other Players) ---
          currentX = targetPixelX; // Locked to the target column

          // Fall from 150 pixels above the board
          final skyStartY = -150.0;
          currentY = skyStartY + ((targetPixelY - skyStartY) * progress);
        }

        return Positioned(
          left: currentX,
          top: currentY,
          width: tileSize,
          height: tileSize,
          child: const Center(
            // TODO Replace this with an Image.asset('assets/bomb.png') later!
            child: Icon(Icons.sports_baseball, color: Colors.black, size: 40),
          ),
        );
      },
    );
  }

  // --- KABOOM EXPLOSION ANIMATION ---
  Widget _buildExplosionAnimation(ActiveTileAnimationEntity anim, double tileSize) {
    return Positioned(
      key: ValueKey(anim.id),
      left: anim.x * tileSize,
      top: anim.y * tileSize,
      width: tileSize,
      height: tileSize,
      child: Container(
        color: retroYellow,
        child: const Center(
          child: Icon(Icons.flash_on, color: retroRed, size: 48),
        ),
      ),
    );
  }

  // --- GHOST DEATH ANIMATION ---
  Widget _buildDeathAnimation(ActiveTileAnimationEntity anim, double tileSize) {
    final targetX = anim.x * tileSize;
    final startY = anim.y * tileSize;
    final targetY = startY - (tileSize * 1.5);

    return TweenAnimationBuilder<double>(
      key: ValueKey(anim.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: anim_constant.deathGhost,
      curve: Curves.easeOut,
      builder: (context, progress, child) {
        final currentY = startY - ((startY - targetY) * progress);
        final currentOpacity = 1.0 - progress;

        return Positioned(
          left: targetX,
          top: currentY,
          width: tileSize,
          height: tileSize,
          child: Opacity(
            opacity: currentOpacity,
            child: const Center(
              child: Icon(
                // TODO update this with ghost / skull icon.
                Icons.sentiment_very_dissatisfied,
                color: Colors.white70,
                size: 40,
                shadows: [Shadow(color: retroRed, blurRadius: 10)],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- ORBITAL LASER ANIMATION ---
  Widget _buildLaserAnimation(ActiveTileAnimationEntity anim, double tileSize) {
    final targetX = anim.x * tileSize;

    // The laser needs to reach from off-screen top all the way down to the bottom of the target tile
    final targetBottomY = (anim.y + 1) * tileSize;

    return TweenAnimationBuilder<double>(
      key: ValueKey(anim.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: anim_constant.laserBeam,
      curve: Curves.easeOutExpo, // Slams down instantly, then lingers
      builder: (context, progress, child) {
        // The beam grows downwards extremely fast
        final currentHeight = targetBottomY * (progress * 2).clamp(0.0, 1.0);

        // After it hits the ground (progress > 0.5), it starts to fade away
        final opacity = progress < 0.5 ? 1.0 : 1.0 - ((progress - 0.5) * 2);

        return Positioned(
          left: targetX,
          top: -50, // Start slightly above the board
          width: tileSize,
          height: currentHeight + 50,
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                // A harsh, bright cyan/white core with a glowing border
                color: Colors.white,
                border: Border.symmetric(
                  vertical: BorderSide(color: retroCyan, width: 8),
                ),
                boxShadow: const [
                  BoxShadow(color: retroCyan, blurRadius: 20, spreadRadius: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- 1. STATIC LOCAL AVATAR (Post-Animation) ---
  Widget _buildStaticLocalPlayer(SimpleModeController ctl, double tileSize) {
    final player = ctl.localPlayer;
    if (player == null || !player.isAlive || player.x == null || player.y == null || !player.hasPositioned) {
      return const SizedBox.shrink();
    }

    // Don't draw the static avatar if the animation is currently playing!
    if (ctl.activeHideAnimations.any((a) => a.playerId == player.id)) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: player.x! * tileSize,
      top: player.y! * tileSize,
      width: tileSize,
      height: tileSize,
      child: const Opacity(
        opacity: 0.5, // Stealth mode
        child: Center(
          child: Icon(
            Icons.android,
            color: retroCyan,
            size: 40,
            shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
          ),
        ),
      ),
    );
  }

  // --- 2. DYNAMIC HIDE SEQUENCE ---
  Widget _buildHideSequence(ActiveHideAnimationEntity anim, double tileSize) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(anim.id),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: anim_constant.hideSequence, // 2.5 seconds total
      curve: Curves.linear, // Robotic, arcade movement
      builder: (context, progress, child) {
        double currentX, currentY, currentOpacity;

        // PHASE 1 (0.0 to 0.4 / First 1.0s): Walk from Off-screen to Edge
        if (progress <= 0.4) {
          final factor = progress / 0.4;
          currentX = anim.startX + ((anim.edgeX - anim.startX) * factor);
          currentY = anim.startY + ((anim.edgeY - anim.startY) * factor);
          currentOpacity = 1.0; // Fully visible
        }
        // PHASE 2 (0.4 to 0.6 / Next 0.5s): Pause at Edge & Fade
        else if (progress <= 0.6) {
          final factor = (progress - 0.4) / 0.2;
          currentX = anim.edgeX.toDouble();
          currentY = anim.edgeY.toDouble();

          // Local fades to 50%, Others fade to 0%
          currentOpacity = anim.isLocal ? 1.0 - (0.5 * factor) : 1.0 - factor;
        }
        // PHASE 3 (0.6 to 1.0 / Final 1.0s): Walk to Target (Local) or vanish (Others)
        else {
          final factor = (progress - 0.6) / 0.4;
          if (anim.isLocal && anim.targetX != null && anim.targetY != null) {
            currentX = anim.edgeX + ((anim.targetX! - anim.edgeX) * factor);
            currentY = anim.edgeY + ((anim.targetY! - anim.edgeY) * factor);
            currentOpacity = 0.5;
          } else {
            currentX = anim.edgeX.toDouble();
            currentY = anim.edgeY.toDouble();
            currentOpacity = 0.0; // Completely hidden
          }
        }

        return Positioned(
          left: currentX * tileSize,
          top: currentY * tileSize,
          width: tileSize,
          height: tileSize,
          child: Opacity(
            opacity: currentOpacity,
            child: const Center(
              child: Icon(Icons.android, color: retroCyan, size: 40),
            ),
          ),
        );
      },
    );
  }
}

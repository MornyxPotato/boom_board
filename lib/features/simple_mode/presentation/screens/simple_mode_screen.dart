import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/presentation/widgets/retro_dialog.dart';
import 'package:boom_board/core/presentation/widgets/retro_loading_text.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';
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
                          if (ctl.currentState != GameState.lobby && ctl.currentState != GameState.end)
                            Text(
                              'PHASE:${ctl.currentState.toString().toUpperCase()}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          // LOBBY CONTROLS (Start Game)
                          if (ctl.currentState == GameState.lobby) ...[
                            if (ctl.isHost)
                              RetroButton(
                                text: 'Start game',
                                color: retroGreen,
                                onPressed: controller.startGame,
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
                                color: retroCyan,
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
                          itemCount: ctl.actionLogList.length,
                          itemBuilder: (context, index) {
                            return Text(
                              '> ${ctl.actionLogList[index].type}',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 16,
                              ),
                            );
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

                    return GridView.builder(
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
}

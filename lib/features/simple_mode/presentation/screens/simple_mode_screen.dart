import 'package:boom_board/core/presentation/widgets/retro_button.dart';
import 'package:boom_board/core/presentation/widgets/retro_dialog.dart';
import 'package:boom_board/core/style/app_colors.dart';
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
                      return Text(
                        'PHASE: ${ctl.currentState.toString().toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
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
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: player.isAlive ? Colors.black : Colors.red[900],
                              border: Border.all(
                                color: player.id == controller.hostId ? retroYellow : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  player.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                // Placeholder for Status Icons (Checkmarks, Skulls, etc.)
                                Text(
                                  player.hasPositioned ? '[OK]' : '[..]',
                                  style: const TextStyle(
                                    color: retroGreen,
                                    fontSize: 20,
                                  ),
                                ),
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
        Row(
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
                // We use a GridView for easy X/Y plotting later
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // No scrolling allowed
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, index) {
                    // Calculate X (column) and Y (row) from 0-7
                    final x = index % 8;
                    final y = index ~/ 8;

                    // Checkerboard pattern for that classic strategy look
                    final isDark = (x + y) % 2 == 1;

                    return Container(
                      color: isDark ? retroGrey : retroGridLight,
                      // We will add the MouseRegion and InkWell here in Phase 2
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
}

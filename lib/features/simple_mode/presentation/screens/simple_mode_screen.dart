import 'package:boom_board/core/style/app_colors.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';
import 'package:boom_board/features/simple_mode/presentation/controllers/simple_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleModeScreen extends GetView<SimpleModeController> {
  const SimpleModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          GetBuilder<SimpleModeController>(
            id: SimpleModeIds.playerListPanel,
            builder: (ctl) {
              return SizedBox(
                height: ctl.playerList.length * 40,
                child: ListView.builder(
                  itemExtent: 40,
                  itemCount: ctl.playerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final player = ctl.playerList[index];
                    return Text(
                      'Player name : ${player.name} has position: ${player.hasPositioned} hasThrownBomb ${player.hasThrowBomb} is alive: ${player.isAlive} is disconnect: ${player.isDisconnected}',
                    );
                  },
                ),
              );
            },
          ),
          GetBuilder<SimpleModeController>(
            id: SimpleModeIds.actionLogPanel,
            builder: (ctl) {
              return SizedBox(
                height: ctl.actionLogList.length * 40,
                child: ListView.builder(
                  itemExtent: 40,
                  itemCount: ctl.actionLogList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final log = ctl.actionLogList[index];
                    return Text('Log data : ${log.toString()}');
                  },
                ),
              );
            },
          ),
          GetBuilder<SimpleModeController>(
            id: SimpleModeIds.boardPanel,
            builder: (ctl) {
              return SizedBox(
                height: ctl.destroyedTile.length * 40,
                child: ListView.builder(
                  itemExtent: 40,
                  itemCount: ctl.destroyedTile.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tile = ctl.destroyedTile[index];
                    return Text('destroyed tile is : ${tile.toString()}');
                  },
                ),
              );
            },
          ),
          GetBuilder<SimpleModeController>(
            id: SimpleModeIds.controlPanel,
            builder: (ctl) {
              return Column(
                children: [
                  Text('Current state is ${ctl.currentState}'),
                  Text('roomCode is ${ctl.roomCode}'),
                  if (ctl.currentState == GameState.lobby && ctl.isHost)
                    TextButton(
                      onPressed: controller.startGame,
                      child: Text(
                        'Start',
                      ),
                    ),
                  if (ctl.currentState == GameState.position)
                    Row(
                      children: [
                        SizedBox(
                          width: 500,
                          child: TextField(
                            controller: ctl.textEditingController,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.setPosition,
                          child: Text('ok'),
                        ),
                      ],
                    ),
                  if (ctl.currentState == GameState.attack)
                    Row(
                      children: [
                        SizedBox(
                          width: 500,
                          child: TextField(
                            controller: ctl.textEditingController,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.throwBomb,
                          child: Text('ok'),
                        ),
                      ],
                    ),
                  if (ctl.currentState == GameState.end && ctl.isHost)
                    TextButton(
                      onPressed: controller.backToLobby,
                      child: Text(
                        'Restart',
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

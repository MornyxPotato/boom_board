import 'dart:async';

import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/core/domain/use_cases/get_current_player_id_use_case.dart';
import 'package:boom_board/core/events/event_bus.dart';
import 'package:boom_board/core/events/models/socket_connected_error_event.dart';
import 'package:boom_board/core/events/models/socket_disconnected_event.dart';
import 'package:boom_board/core/style/app_colors.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';
import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/game_over_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/game_reset_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/game_started_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/phase_changed_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/player_dropped_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/player_joined_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/player_left_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/player_ready_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/round_resolved_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/reset_game_use_case.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/set_position_use_case.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/start_game_use_case.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/throw_bomb_use_case.dart';
import 'package:boom_board/features/simple_mode/presentation/arguments/simple_mode_arguments.dart';
import 'package:boom_board/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

abstract class SimpleModeIds {
  static const String playerListPanel = 'PLAYER_LIST_PANEL';
  static const String actionLogPanel = 'ACTION_LOG_PANEL';
  static const String boardPanel = 'BOARD_PANEL';
  static const String controlPanel = 'CONTROL_PANEL';
}

class SimpleModeController extends GetxController {
  String roomCode = '';
  String hostId = '';
  GameState currentState = GameState.lobby;
  List<SimpleModePlayerEntity> playerList = [];
  List<ActionLogEntity> actionLogList = [];
  List<Coordinate> destroyedTile = [];
  TextEditingController textEditingController = TextEditingController();

  StreamSubscription? playerJoinEventSubs;
  StreamSubscription? playerLeftEventSubs;
  StreamSubscription? playerReadyEventSubs;
  StreamSubscription? playerDroppedEventSubs;
  StreamSubscription? gameStartedEventSubs;
  StreamSubscription? phaseChangedEventSubs;
  StreamSubscription? roundResolvedEventSubs;
  StreamSubscription? gameOverEventSubs;
  StreamSubscription? gameResetEventSubs;
  StreamSubscription? socketDisconnectedSubs;
  StreamSubscription? socketErrorSubs;

  bool get isHost {
    return hostId == GetIt.I<GetCurrentPlayerIdUseCase>().call();
  }

  Logger get logger {
    return GetIt.I<Logger>();
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is! SimpleModeArguments) {
      Get.offAllNamed(home);
      return;
    }
    final args = Get.arguments as SimpleModeArguments;
    roomCode = args.roomCode;
    hostId = args.hostId;
    playerList = args.playerList;

    subscribeListener();
  }

  @override
  void onClose() {
    super.onClose();

    unsubscribeListener();
  }

  void subscribeListener() {
    playerJoinEventSubs = eventBus.on<PlayerJoinedEvent>().listen(onPlayerJoinedEventReceived);
    playerLeftEventSubs = eventBus.on<PlayerLeftEvent>().listen(onPlayerLeftEventReceived);
    playerReadyEventSubs = eventBus.on<PlayerReadyEvent>().listen(onPlayerReadyEventReceived);
    playerDroppedEventSubs = eventBus.on<PlayerDroppedEvent>().listen(onPlayerDroppedEventReceived);
    gameStartedEventSubs = eventBus.on<GameStartedEvent>().listen(onGameStartEventReceived);
    phaseChangedEventSubs = eventBus.on<PhaseChangedEvent>().listen(onPhaseChangedEventReceived);
    roundResolvedEventSubs = eventBus.on<RoundResolvedEvent>().listen(onRoundResolvedEventReceived);
    gameOverEventSubs = eventBus.on<GameOverEvent>().listen(onGameOverEventReceived);
    gameResetEventSubs = eventBus.on<GameResetEvent>().listen(onGameResetEventReceived);
    socketDisconnectedSubs = eventBus.on<SocketDisconnectedEvent>().listen(_onConnectionLost);
    socketErrorSubs = eventBus.on<SocketConnectedErrorEvent>().listen(_onConnectionLost);
  }

  void unsubscribeListener() {
    playerJoinEventSubs?.cancel();
    playerLeftEventSubs?.cancel();
    playerReadyEventSubs?.cancel();
    playerDroppedEventSubs?.cancel();
    gameStartedEventSubs?.cancel();
    phaseChangedEventSubs?.cancel();
    roundResolvedEventSubs?.cancel();
    gameOverEventSubs?.cancel();
    gameResetEventSubs?.cancel();
    socketDisconnectedSubs?.cancel();
    socketErrorSubs?.cancel();
  }

  void resetRound() {
    actionLogList = [];
    destroyedTile = [];
    currentState = GameState.lobby;
  }

  void startGame() async {
    if (isHost) {
      try {
        await GetIt.I<StartGameUseCase>().call(StartGameParams(roomCode: roomCode));
      } catch (e, stackTrace) {
        logger.e('startGame error.', error: e, stackTrace: stackTrace);
      }
    }
  }

  void setPosition() async {
    try {
      final String text = textEditingController.text;
      final data = text.split(',');
      await GetIt.I<SetPositionUseCase>().call(
        SetPositionParams(
          roomCode: roomCode,
          x: int.parse(data.first),
          y: int.parse(data.last),
        ),
      );
      textEditingController.clear();
      final index = playerList.indexWhere((e) => e.id == GetIt.I<GetCurrentPlayerIdUseCase>().call());
      if (index != 1) {
        playerList[index] = playerList[index].copyWith(hasPositioned: true);
      }
    } catch (e, stackTrace) {
      logger.e('setPosition error.', error: e, stackTrace: stackTrace);
    }
  }

  void throwBomb() async {
    try {
      final String text = textEditingController.text;
      final data = text.split(',');
      await GetIt.I<ThrowBombUseCase>().call(
        ThrowBombParams(
          roomCode: roomCode,
          x: int.parse(data.first),
          y: int.parse(data.last),
        ),
      );
      final index = playerList.indexWhere((e) => e.id == GetIt.I<GetCurrentPlayerIdUseCase>().call());
      if (index != 1) {
        playerList[index] = playerList[index].copyWith(hasThrowBomb: true);
      }
      textEditingController.clear();
    } catch (e, stackTrace) {
      logger.e('throwBomb error.', error: e, stackTrace: stackTrace);
    }
  }

  void backToLobby() async {
    try {
      await GetIt.I<ResetGameUseCase>().call(ResetGameParams(roomCode: roomCode));
    } catch (e, stackTrace) {
      logger.e('backToLobby error.', error: e, stackTrace: stackTrace);
    }
  }

  void onPlayerJoinedEventReceived(PlayerJoinedEvent event) {
    logger.d('onPlayerJoinedEventReceived called with $event');
    playerList = event.playerList;
    update([SimpleModeIds.playerListPanel]);
  }

  void onPlayerLeftEventReceived(PlayerLeftEvent event) {
    logger.d('onPlayerLeftEventReceived called with $event');
    playerList = event.playerList;
    hostId = event.newHostId;
    update([SimpleModeIds.playerListPanel]);
  }

  void onPlayerReadyEventReceived(PlayerReadyEvent event) {
    logger.d('onPlayerReadyEventReceived called with $event');
    final index = playerList.indexWhere((e) => e.id == event.playerId);
    if (index != -1) {
      if (currentState == GameState.position) {
        playerList[index] = playerList[index].copyWith(hasPositioned: true);
      } else if (currentState == GameState.attack) {
        playerList[index] = playerList[index].copyWith(hasThrowBomb: true);
      }
      update([SimpleModeIds.playerListPanel]);
    }
  }

  void onPlayerDroppedEventReceived(PlayerDroppedEvent event) {
    logger.d('onPlayerDroppedEventReceived called with $event');
    playerList = event.playerList;
    hostId = event.newHostId;
    actionLogList.addAll(event.newLogs);
    update([SimpleModeIds.playerListPanel, SimpleModeIds.actionLogPanel, SimpleModeIds.controlPanel]);
  }

  void onGameStartEventReceived(GameStartedEvent event) {
    logger.d('onGameStartEventReceived called with $event');
    currentState = event.state;
    destroyedTile = event.destroyedTiles;
    update([SimpleModeIds.controlPanel, SimpleModeIds.boardPanel]);
  }

  void onPhaseChangedEventReceived(PhaseChangedEvent event) {
    logger.d('onPhaseChangedEventReceived called with $event');
    currentState = event.state;

    if (currentState == GameState.attack) {
      for (int i = 0; i < playerList.length; i++) {
        playerList[i] = playerList[i].copyWith(
          hasThrowBomb: false,
          hasPositioned: true,
        );
      }
      update([SimpleModeIds.playerListPanel]);
    }

    update([SimpleModeIds.controlPanel]);
  }

  void onRoundResolvedEventReceived(RoundResolvedEvent event) async {
    logger.d('onRoundResolvedEventReceived called with $event');

    // Temporarily lock UI into a 'process' state so players can't click things
    currentState = GameState.process;
    update([SimpleModeIds.controlPanel]);

    // Add Orbital Laser damage immediately
    destroyedTile.addAll(event.destroyedTiles);
    update([SimpleModeIds.boardPanel]);

    // SEQUENTIAL EXPLOSION LOGIC
    // Even in a temporary UI, we use async/await inside a loop to process them one-by-one
    for (var explosion in event.explosionList) {
      // NOTE: When you build the real UI, this is where you trigger the
      // visual bomb explosion animation on the specific grid coordinates (explosion.x, explosion.y)

      // Wait for the "animation" to finish before evaluating the result
      await Future.delayed(const Duration(seconds: 1));

      if (explosion.isHit && explosion.victimId != null) {
        // Update the victim's status in real-time
        final victimIndex = playerList.indexWhere((p) => p.name == explosion.victimId);
        if (victimIndex != -1) {
          playerList[victimIndex] = playerList[victimIndex].copyWith(isAlive: false);
          update([SimpleModeIds.playerListPanel]);
        }
      }
    }

    // 4. Final Sync: Ensure our local list perfectly matches the server's master list
    playerList = event.playerList;
    actionLogList.addAll(event.newLogs);

    // We don't update state to 'attack' here, we wait for the server's PhaseChangedEvent
    update([SimpleModeIds.playerListPanel, SimpleModeIds.actionLogPanel]);
  }

  void onGameOverEventReceived(GameOverEvent event) {
    logger.d('onGameOverEventReceived called with $event');
    currentState = GameState.end;
    update([SimpleModeIds.controlPanel]);
  }

  void onGameResetEventReceived(GameResetEvent event) {
    logger.d('onGameResetEventReceived called with $event');
    resetRound();
    playerList = event.playerList;
    update([
      SimpleModeIds.controlPanel,
      SimpleModeIds.playerListPanel,
      SimpleModeIds.boardPanel,
      SimpleModeIds.actionLogPanel,
    ]);
  }

  void _onConnectionLost(dynamic event) {
    logger.e('Socket disconnected! Navigating back to home screen.');
    Get.offAllNamed(home);

    Get.snackbar(
      'Connection Lost',
      'You have been disconnected from the server.',
      backgroundColor: errorColor,
      colorText: textOrIconColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}

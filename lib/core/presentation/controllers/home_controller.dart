import 'dart:async';

import 'package:boom_board/core/data/models/enums/game_mode.dart';
import 'package:boom_board/core/domain/use_cases/connect_to_server_use_case.dart';
import 'package:boom_board/core/domain/use_cases/create_room_use_case.dart';
import 'package:boom_board/core/domain/use_cases/join_room_use_case.dart';
import 'package:boom_board/core/events/event_bus.dart';
import 'package:boom_board/core/events/models/socket_connected_error_event.dart';
import 'package:boom_board/core/events/models/socket_connected_event.dart';
import 'package:boom_board/core/events/models/socket_disconnected_event.dart';
import 'package:boom_board/core/events/models/socket_reconnect_attempt_event.dart';
import 'package:boom_board/core/exceptions/bb_server_exception.dart';
import 'package:boom_board/core/presentation/models/enums/home_panel_type.dart';
import 'package:boom_board/features/simple_mode/data/models/mapper/socket_event_data_mapper.dart';
import 'package:boom_board/features/simple_mode/presentation/arguments/simple_mode_arguments.dart';
import 'package:boom_board/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

abstract class HomeIds {
  static const connectingIndicator = 'CONNECTING_INDICATOR';
  static const connectErrorText = 'CONNECT_ERROR_TEXT';
  static const panel = 'PANEL';
}

class HomeController extends GetxController {
  bool isConnecting = false;
  bool connectedToServer = false;
  HomePanelType panelType = HomePanelType.start;
  String? panelError;

  TextEditingController playerNameTextFieldCtl = TextEditingController();
  TextEditingController roomCodeTextFieldCtl = TextEditingController();

  StreamSubscription? socketConnectedListener;
  StreamSubscription? socketConnectedErrorListener;
  StreamSubscription? socketDisconnectedListener;
  StreamSubscription? socketReconnectAttemptedListener;

  Logger get logger {
    return GetIt.I<Logger>();
  }

  @override
  void onInit() {
    super.onInit();

    subscribeEvent();
    try {
      isConnecting = true;
      GetIt.I<ConnectToServerUseCase>().call();
    } catch (e, stackTrace) {
      logger.e('Connect to server error.', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void onClose() {
    super.onClose();
    socketConnectedListener?.cancel();
    socketConnectedErrorListener?.cancel();
    socketDisconnectedListener?.cancel();
    socketReconnectAttemptedListener?.cancel();
  }

  void subscribeEvent() {
    socketConnectedListener = eventBus.on<SocketConnectedEvent>().listen((event) {
      logger.d('SocketConnectedEvent called');
      connectedToServer = true;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText, HomeIds.panel]);
    });
    socketConnectedErrorListener = eventBus.on<SocketConnectedErrorEvent>().listen((event) {
      logger.d('SocketConnectedErrorEvent called');
      connectedToServer = false;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText, HomeIds.panel]);
    });
    socketDisconnectedListener = eventBus.on<SocketDisconnectedEvent>().listen((event) {
      logger.d('SocketDisconnectedEvent called');
      connectedToServer = false;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText, HomeIds.panel]);
    });
    socketReconnectAttemptedListener = eventBus.on<SocketReconnectAttemptEvent>().listen((event) {
      logger.d('SocketReconnectAttemptEvent called');
      connectedToServer = false;
      isConnecting = true;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText, HomeIds.panel]);
    });
  }

  void onHostPressed() {
    logger.d('onHostPressed called');
    panelError = null;
    panelType = HomePanelType.host;
    update([HomeIds.panel]);
  }

  void onJoinPressed() {
    logger.d('onJoinPressed called');
    panelError = null;
    panelType = HomePanelType.join;
    update([HomeIds.panel]);
  }

  void onCreatePressed() async {
    logger.d('onCreatePressed called');
    try {
      panelError = null; // Clear previous errors
      update([HomeIds.panel]);

      if (playerNameTextFieldCtl.text.trim().isEmpty) {
        panelError = 'Player name required';
        update([HomeIds.panel]);
        return;
      }

      final result = await GetIt.I<CreateRoomUseCase>().call(
        CreateRoomParams(
          playerName: playerNameTextFieldCtl.text.trim(),
        ),
      );
      logger.d('create result from server is ${result.roomCode}');
      if (result.gameMode == GameMode.simple) {
        Get.toNamed(
          simpleMode,
          arguments: SimpleModeArguments(
            roomCode: result.roomCode,
            hostId: result.hostId,
            playerList: result.playerList.toSimpleModeEntity(),
          ),
        );
      }
    } on BBServerException catch (e, stackTrace) {
      logger.e('SimpleModeCreateRoomUseCase BBServerException error.', error: e, stackTrace: stackTrace);
      if (e.errorType == 'INVALID_PLAYER_NAME') {
        panelError = 'Player name must be 1 - 20 characters long';
      } else {
        panelError = 'Unknown server error occurred';
      }
      update([HomeIds.panel]);
    } catch (e, stackTrace) {
      logger.e('SimpleModeCreateRoomUseCase error.', error: e, stackTrace: stackTrace);
      panelError = 'Unknown error occurred';
      update([HomeIds.panel]);
    }
  }

  void onJoinConfirmPressed() async {
    logger.d('onJoinConfirmPressed called');
    try {
      panelError = null; // Clear previous errors
      update([HomeIds.panel]);

      // 1. Client-Side Validation
      if (playerNameTextFieldCtl.text.trim().isEmpty) {
        panelError = 'Player name required';
        update([HomeIds.panel]);
        return;
      }
      if (roomCodeTextFieldCtl.text.trim().length != 4) {
        panelError = 'Invalid room code';
        update([HomeIds.panel]);
        return;
      }

      final result = await GetIt.I<JoinRoomUseCase>().call(
        JoinRoomParams(
          playerName: playerNameTextFieldCtl.text,
          roomCode: roomCodeTextFieldCtl.text,
        ),
      );
      logger.d('join result from server is ${result.playerList} gameMode is ${result.gameMode}');
      if (result.gameMode == GameMode.simple) {
        Get.toNamed(
          simpleMode,
          arguments: SimpleModeArguments(
            roomCode: result.roomCode,
            hostId: result.hostId,
            playerList: result.playerList.toSimpleModeEntity(),
          ),
        );
      }
    } on BBServerException catch (e, stackTrace) {
      logger.e('SimpleModeJoinRoomUseCase BBServerException error.', error: e, stackTrace: stackTrace);
      if (e.errorType == 'ROOM_NOT_FOUND') {
        panelError = 'Room ${roomCodeTextFieldCtl.text} not found';
      } else if (e.errorType == 'GAME_ALREADY_STARTED') {
        panelError = 'Game already started. Please wait';
      } else if (e.errorType == 'ROOM_IS_FULL') {
        panelError = 'Room is full';
      } else if (e.errorType == 'PLAYER_ALREADY_IN_ROOM') {
        panelError = 'You are already in this room';
      } else if (e.errorType == 'INVALID_PLAYER_NAME') {
        panelError = 'Player name must be 1 - 20 characters long';
      }
      update([HomeIds.panel]);
    } catch (e, stackTrace) {
      logger.e('SimpleModeJoinRoomUseCase error.', error: e, stackTrace: stackTrace);
      panelError = 'Unknown error occurred';
      update([HomeIds.panel]);
    }
  }

  void onCancelPressed() {
    logger.d('onCancelPressed called');
    panelError = null;
    panelType = HomePanelType.start;
    playerNameTextFieldCtl.clear();
    roomCodeTextFieldCtl.clear();
    update([HomeIds.panel]);
  }
}

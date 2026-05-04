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
      connectedToServer = true;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText]);
    });
    socketConnectedErrorListener = eventBus.on<SocketConnectedErrorEvent>().listen((event) {
      connectedToServer = false;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText]);
    });
    socketDisconnectedListener = eventBus.on<SocketDisconnectedEvent>().listen((event) {
      connectedToServer = false;
      isConnecting = false;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText]);
    });
    socketReconnectAttemptedListener = eventBus.on<SocketReconnectAttemptEvent>().listen((event) {
      connectedToServer = false;
      isConnecting = true;
      update([HomeIds.connectingIndicator, HomeIds.connectErrorText]);
    });
  }

  void onHostPressed() {
    logger.d('onHostPressed called');
    panelType = HomePanelType.host;
    update([HomeIds.panel]);
  }

  void onJoinPressed() {
    logger.d('onJoinPressed called');
    panelType = HomePanelType.join;
    update([HomeIds.panel]);
  }

  void onCreatePressed() async {
    logger.d('onCreatePressed called');
    try {
      final result = await GetIt.I<CreateRoomUseCase>().call(
        CreateRoomParams(
          playerName: playerNameTextFieldCtl.text,
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
    } catch (e, stackTrace) {
      logger.e('SimpleModeCreateRoomUseCase error.', error: e, stackTrace: stackTrace);
    }
  }

  void onJoinConfirmPressed() async {
    logger.d('onJoinConfirmPressed called');
    try {
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
    } catch (e, stackTrace) {
      logger.e('SimpleModeJoinRoomUseCase error.', error: e, stackTrace: stackTrace);
    }
  }

  void onCancelPressed() {
    logger.d('onCancelPressed called');
    panelType = HomePanelType.start;
    playerNameTextFieldCtl.clear();
    roomCodeTextFieldCtl.clear();
    update([HomeIds.panel]);
  }
}

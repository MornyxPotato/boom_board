import 'package:boom_board/core/domain/use_cases/get_current_player_id_use_case.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/log_action_type.dart';
import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/player_dropped_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/events/round_resolved_event.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/set_position_use_case.dart';
import 'package:boom_board/features/simple_mode/domain/use_cases/start_game_use_case.dart';
import 'package:boom_board/features/simple_mode/presentation/arguments/simple_mode_arguments.dart';
import 'package:boom_board/features/simple_mode/presentation/controllers/simple_mode_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

// --- 1. Create Mocks using Mocktail ---
class MockStartGameUseCase extends Mock implements StartGameUseCase {}

class MockGetCurrentPlayerIdUseCase extends Mock implements GetCurrentPlayerIdUseCase {}

class MockSetPositionUseCase extends Mock implements SetPositionUseCase {}

class MockLogger extends Mock implements Logger {}

class FakeSetPositionParams extends Fake implements SetPositionParams {}

void main() {
  late SimpleModeController controller;
  late MockStartGameUseCase mockStartGameUseCase;
  late MockGetCurrentPlayerIdUseCase mockGetCurrentPlayerIdUseCase;
  late MockSetPositionUseCase mockSetPositionUseCase;
  late MockLogger mockLogger;

  // Dummy data for testing
  const testRoomCode = 'ABCD';
  const testHostId = 'player_1';
  final testPlayers = [
    SimpleModePlayerEntity(
      id: 'player_1',
      name: 'Host',
      isAlive: true,
      isDisconnected: false,
      hasPositioned: false,
      hasThrowBomb: false,
    ),
    SimpleModePlayerEntity(
      id: 'player_2',
      name: 'Guest',
      isAlive: true,
      isDisconnected: false,
      hasPositioned: false,
      hasThrowBomb: false,
    ),
  ];

  setUpAll(() {
    // Register fallback values for mocktail if you ever need to pass complex objects to 'any()'
    registerFallbackValue(StartGameParams(roomCode: 'dummy'));
    registerFallbackValue(FakeSetPositionParams());
  });

  setUp(() {
    // --- 2. Sandbox GetIt ---
    GetIt.I.allowReassignment = true;
    mockStartGameUseCase = MockStartGameUseCase();
    mockGetCurrentPlayerIdUseCase = MockGetCurrentPlayerIdUseCase();
    mockSetPositionUseCase = MockSetPositionUseCase();

    mockLogger = MockLogger();

    GetIt.I.registerSingleton<StartGameUseCase>(mockStartGameUseCase);
    GetIt.I.registerSingleton<GetCurrentPlayerIdUseCase>(mockGetCurrentPlayerIdUseCase);
    GetIt.I.registerSingleton<SetPositionUseCase>(mockSetPositionUseCase);
    GetIt.I.registerSingleton<Logger>(mockLogger);

    // --- 3. Initialize Controller ---
    // We instantiate it directly rather than using Get.put to keep the test environment clean
    controller = SimpleModeController(
      args: SimpleModeArguments(
        roomCode: testRoomCode,
        hostId: testHostId,
        playerList: testPlayers,
      ),
    );

    // Simulate what GetX does when a controller is put into memory
    controller.onInit();
  });

  tearDown(() {
    // Clean up memory after each test
    controller.dispose();
    Get.reset();
    GetIt.I.reset();
  });

  group('SimpleModeController - Initialization', () {
    test('should properly assign arguments to local variables onInit', () {
      expect(controller.roomCode, testRoomCode);
      expect(controller.hostId, testHostId);
      expect(controller.playerList.length, 2);
    });
  });

  group('SimpleModeController - startGame()', () {
    test('should call StartGameUseCase when player is Host and there is more than 1 player', () async {
      // Arrange
      // Since localPlayerId isn't explicitly set in arguments without a usecase,
      // we mock the behavior of success for the use case.
      when(() => mockStartGameUseCase.call(any())).thenAnswer((_) async {});
      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn(testHostId);

      // Act
      controller.startGame();

      // Assert
      // Verify that the UseCase was called exactly once with the correct roomCode
      verify(
        () => mockStartGameUseCase.call(
          any(that: isA<StartGameParams>().having((p) => p.roomCode, 'roomCode', testRoomCode)),
        ),
      ).called(1);
    });

    test('should NOT call StartGameUseCase if player count is 1 or less', () async {
      // Arrange
      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn(testHostId);
      controller.playerList = [testPlayers.first]; // Only 1 player

      // Act
      controller.startGame();

      // Assert
      verifyNever(() => mockStartGameUseCase.call(any()));
    });

    test('should NOT call StartGameUseCase if local player is NOT the host', () async {
      // Arrange
      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn('player_2');

      // Act
      controller.startGame();

      // Assert
      verifyNever(() => mockStartGameUseCase.call(any()));
    });
  });

  group('SimpleModeController - User Actions (setPosition)', () {
    test('should NOT call SetPositionUseCase if localPlayer has already positioned', () async {
      // Arrange
      // Setup the local player so hasPositioned is true
      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn(testHostId);
      controller.playerList = [
        SimpleModePlayerEntity(
          id: testHostId,
          name: 'Host',
          isAlive: true,
          isDisconnected: false,
          hasPositioned: true,
          hasThrowBomb: false,
        ),
      ];

      // Act
      controller.setPosition(2, 3);

      // Assert
      // Verify the use case is never fired, protecting against double-submits
      verifyNever(() => mockSetPositionUseCase.call(any()));
    });

    test('should NOT call SetPositionUseCase if localPlayer is null', () async {
      // Arrange
      // Local player ID doesn't match any player in the list
      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn('unknown_id');

      // Act
      controller.setPosition(2, 3);

      // Assert
      verifyNever(() => mockSetPositionUseCase.call(any()));
    });
  });

  group('SimpleModeController - Socket Event Handlers', () {
    test('should update playerList, hostId, and actionLogList when PlayerDroppedEvent is received', () {
      // Arrange
      final newLogs = [
        ActionLogEntity(
          id: 'log_1',
          type: LogActionType.playerDisconnected,
          timestamp: DateTime.now(),
          data: {},
        ),
      ];

      final droppedEvent = PlayerDroppedEvent(
        droppedPlayerId: 'player_2',
        newHostId: 'player_1',
        playerList: [
          SimpleModePlayerEntity(
            id: 'player_1',
            name: 'Host',
            isAlive: true,
            isDisconnected: false,
            hasPositioned: false,
            hasThrowBomb: false,
          ),
        ],
        newLogs: newLogs,
      );

      // Set initial state to ensure it actually changes
      controller.hostId = 'player_2';
      controller.playerList = [];
      controller.actionLogList = [];

      // Act
      controller.onPlayerDroppedEventReceived(droppedEvent);

      // Assert
      expect(controller.hostId, 'player_1');
      expect(controller.playerList.length, 1);
      expect(controller.actionLogList.length, 1);
      expect(controller.actionLogList.first.id, 'log_1');
    });

    test('should process RoundResolvedEvent, preserve local player coordinates, and update logs', () {
      // Arrange
      // 1. Setup the pre-existing state of the controller
      controller.currentRound = 1;
      controller.actionLogList = [
        ActionLogEntity(id: 'old_log', type: LogActionType.playerDisconnected, timestamp: DateTime.now(), data: {}),
      ];

      // The current player list before the event
      controller.playerList = [
        SimpleModePlayerEntity(
          id: testHostId,
          name: 'Host',
          isAlive: true,
          isDisconnected: false,
          hasPositioned: true,
          hasThrowBomb: true,
          x: 3,
          y: 4,
        ),
        SimpleModePlayerEntity(
          id: 'player_2',
          name: 'Guest',
          isAlive: true,
          isDisconnected: false,
          hasPositioned: true,
          hasThrowBomb: true,
        ),
      ];

      // 2. Setup the incoming Event data
      // Note: The server sends the player list back, but typically WITHOUT the hidden x/y coordinates of the local player!
      final incomingPlayerList = [
        SimpleModePlayerEntity(
          id: testHostId,
          name: 'Host',
          isAlive: true,
          isDisconnected: false,
          hasPositioned: true,
          hasThrowBomb: true,
          x: null,
          y: null,
        ), // Server stripped coordinates
        SimpleModePlayerEntity(
          id: 'player_2',
          name: 'Guest',
          isAlive: false,
          isDisconnected: false,
          hasPositioned: true,
          hasThrowBomb: true,
        ), // Guest died!
      ];

      final newLogs = [
        ActionLogEntity(id: 'new_log_1', type: LogActionType.playerEliminated, timestamp: DateTime.now(), data: {}),
      ];

      final event = RoundResolvedEvent(
        roundNumber: 2,
        explosionList: [], // Add mock explosions here if your method processes them directly
        playerList: incomingPlayerList,
        destroyedTiles: [],
        newDestroyedTiles: [],
        newLogs: newLogs,
      );

      when(() => mockGetCurrentPlayerIdUseCase.call()).thenReturn(testHostId);

      // Act
      controller.onRoundResolvedEventReceived(event);

      // Assert
      // A. Check Round Number
      expect(controller.currentRound, 2, reason: 'Round number should update to the event roundNumber');

      // B. Check Logs Appended
      expect(controller.actionLogList.length, 2, reason: 'New logs should be appended to existing logs');
      expect(controller.actionLogList.last.id, 'new_log_1');

      // C. CRUCIAL: Check Local Player Coordinate Restoration
      final localPlayerAfterEvent = controller.playerList.firstWhere((p) => p.id == testHostId);
      expect(localPlayerAfterEvent.x, 3, reason: 'Local X coordinate should be restored after server update');
      expect(localPlayerAfterEvent.y, 4, reason: 'Local Y coordinate should be restored after server update');

      // D. Check other player state updated
      final guestPlayerAfterEvent = controller.playerList.firstWhere((p) => p.id == 'player_2');
      expect(
        guestPlayerAfterEvent.isAlive,
        false,
        reason: 'Other player states (like death) should be updated from the server list',
      );
    });
  });
}

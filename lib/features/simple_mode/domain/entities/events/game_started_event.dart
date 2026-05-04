import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';

class GameStartedEvent {
  final int boardWidth;
  final int boardHeight;
  final GameState state;
  final List<Coordinate> destroyedTiles;
  final int timeLimit;

  GameStartedEvent({
    required this.boardWidth,
    required this.boardHeight,
    required this.state,
    required this.destroyedTiles,
    required this.timeLimit,
  });

  @override
  String toString() {
    return 'GameStartedEvent boardWidth: $boardWidth, boardHeight: $boardHeight, state: $state, destroyedTiles: $destroyedTiles, timeLimit: $timeLimit';
  }
}

import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';

class GameStartedModel {
  final int boardWidth;
  final int boardHeight;
  final GameState state;
  final List<Coordinate> destroyedTiles;
  final int timeLimit;

  GameStartedModel({
    required this.boardWidth,
    required this.boardHeight,
    required this.state,
    required this.destroyedTiles,
    required this.timeLimit,
  });

  static GameStartedModel fromJson(Map<String, dynamic> json) {
    final List<Coordinate> destroyedTiles = [];
    for (final coordinate in json['destroyedTiles']) {
      destroyedTiles.add(Coordinate.fromJson(coordinate));
    }

    return GameStartedModel(
      boardWidth: json['boardSize']['width'],
      boardHeight: json['boardSize']['height'],
      state: GameState.fromString(json['state']),
      destroyedTiles: destroyedTiles,
      timeLimit: json['timeLimit'],
    );
  }
}

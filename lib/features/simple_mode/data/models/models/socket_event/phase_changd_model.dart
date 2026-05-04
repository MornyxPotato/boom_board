import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';

class PhaseChangedModel {
  final GameState state;
  final int timeLimit;

  PhaseChangedModel({
    required this.state,
    required this.timeLimit,
  });

  static PhaseChangedModel fromJson(Map<String, dynamic> json) {
    return PhaseChangedModel(
      state: GameState.fromString(json['phase']),
      timeLimit: json['timeLimit'],
    );
  }
}

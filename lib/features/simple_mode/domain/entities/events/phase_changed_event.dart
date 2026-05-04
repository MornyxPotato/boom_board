import 'package:boom_board/features/simple_mode/data/models/enum/game_state.dart';

class PhaseChangedEvent {
  final GameState state;
  final int timeLimit;

  PhaseChangedEvent({
    required this.state,
    required this.timeLimit,
  });

  @override
  String toString() {
    return 'PhaseChangedEvent state: $state, timeLimit: $timeLimit';
  }
}

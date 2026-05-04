import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_result_entity.dart';

class GameOverEvent {
  final List<SimpleModeResultEntity> ranking;

  GameOverEvent({required this.ranking});

  @override
  String toString() {
    return 'GameOverEvent ranking: $ranking';
  }
}

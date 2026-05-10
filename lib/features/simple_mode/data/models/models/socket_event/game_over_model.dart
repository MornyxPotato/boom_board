import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/features/simple_mode/data/models/models/simple_mode_result_model.dart';

class GameOverModel {
  final List<SimpleModeResultModel> ranking;
  final Coordinate winnerPosition;

  GameOverModel({
    required this.ranking,
    required this.winnerPosition,
  });

  static GameOverModel fromJson(Map<String, dynamic> json) {
    final List<SimpleModeResultModel> ranking = [];
    for (final player in json['ranking']) {
      ranking.add(SimpleModeResultModel.fromJson(player));
    }
    final Coordinate coordinate = Coordinate.fromJson(json['winnerPosition']);

    return GameOverModel(
      ranking: ranking,
      winnerPosition: coordinate,
    );
  }
}

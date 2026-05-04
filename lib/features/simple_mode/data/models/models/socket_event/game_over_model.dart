import 'package:boom_board/features/simple_mode/data/models/models/simple_mode_result_model.dart';

class GameOverModel {
  final List<SimpleModeResultModel> ranking;

  GameOverModel({required this.ranking});

  static GameOverModel fromJson(Map<String, dynamic> json) {
    final List<SimpleModeResultModel> ranking = [];
    for (final player in json['ranking']) {
      ranking.add(SimpleModeResultModel.fromJson(player));
    }

    return GameOverModel(ranking: ranking);
  }
}

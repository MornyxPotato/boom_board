import 'package:boom_board/core/data/models/coordinate.dart';
import 'package:boom_board/core/data/models/models/player_model.dart';
import 'package:boom_board/features/simple_mode/data/models/models/action_log_model.dart';
import 'package:boom_board/features/simple_mode/data/models/models/explosion_result_model.dart';

class RoundResolvedModel {
  final List<ExplosionResultModel> explosionList;
  final List<PlayerModel> playerList;
  final List<Coordinate> destroyedTiles;
  final List<Coordinate> newDestroyedTiles;
  final List<ActionLogModel> newLogs;

  RoundResolvedModel({
    required this.explosionList,
    required this.playerList,
    required this.destroyedTiles,
    required this.newDestroyedTiles,
    required this.newLogs,
  });

  static RoundResolvedModel fromJson(Map<String, dynamic> json) {
    final List<ExplosionResultModel> explosionList = [];
    for (final explosion in json['explosions']) {
      explosionList.add(ExplosionResultModel.fromJson(explosion));
    }

    final List<PlayerModel> playerList = [];
    for (final player in json['remainingPlayers']) {
      playerList.add(PlayerModel.fromJson(player));
    }

    final List<Coordinate> destroyedTiles = [];
    for (final coordinate in json['destroyedTiles']) {
      destroyedTiles.add(Coordinate.fromJson(coordinate));
    }

    final List<Coordinate> newDestroyedTiles = [];
    for (final coordinate in json['newDestroyedTiles']) {
      newDestroyedTiles.add(Coordinate.fromJson(coordinate));
    }

    final List<ActionLogModel> newLogs = [];
    for (final log in json['newLogs']) {
      newLogs.add(ActionLogModel.fromJson(log));
    }

    return RoundResolvedModel(
      explosionList: explosionList,
      playerList: playerList,
      destroyedTiles: destroyedTiles,
      newDestroyedTiles: newDestroyedTiles,
      newLogs: newLogs,
    );
  }
}

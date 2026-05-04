import 'package:boom_board/core/data/models/models/player_model.dart';
import 'package:boom_board/core/domain/entities/player_entity.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_player_entity.dart';

extension PlayerModelSimpleModeExtension on List<PlayerModel> {
  List<SimpleModePlayerEntity> toSimpleModeEntity() {
    return map(
      (e) => SimpleModePlayerEntity(
        id: e.id,
        name: e.name,
        isAlive: e.isAlive,
        hasPositioned: e.hasPositioned,
        hasThrowBomb: false,
        isDisconnected: e.isDisconnected,
      ),
    ).toList();
  }
}

extension PlayerEntitySimpleModeExtension on List<PlayerEntity> {
  List<SimpleModePlayerEntity> toSimpleModeEntity() {
    return map(
      (e) => SimpleModePlayerEntity(
        id: e.id,
        name: e.name,
        isAlive: e.isAlive,
        hasPositioned: e.hasPositioned,
        hasThrowBomb: false,
        isDisconnected: e.isDisconnected,
      ),
    ).toList();
  }
}

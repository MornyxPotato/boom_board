import 'package:boom_board/features/simple_mode/data/models/models/explosion_result_model.dart';
import 'package:boom_board/features/simple_mode/domain/entities/explosion_result_entity.dart';

extension ExplosionResultModelExtension on ExplosionResultModel {
  ExplosionResultEntity toEntity() {
    return ExplosionResultEntity(
      bomberId: bomberId,
      victimId: victimId,
      isHit: isHit,
      x: x,
      y: y,
    );
  }
}

extension ExplosionResultEntityExtension on ExplosionResultEntity {
  ExplosionResultModel toModel() {
    return ExplosionResultModel(
      bomberId: bomberId,
      victimId: victimId,
      isHit: isHit,
      x: x,
      y: y,
    );
  }
}

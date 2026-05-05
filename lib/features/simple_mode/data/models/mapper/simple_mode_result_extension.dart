import 'package:boom_board/features/simple_mode/data/models/models/simple_mode_result_model.dart';
import 'package:boom_board/features/simple_mode/domain/entities/simple_mode_result_entity.dart';

extension SimpleModeResultModelExtension on SimpleModeResultModel {
  SimpleModeResultEntity toEntity() {
    return SimpleModeResultEntity(
      rank: rank,
      id: id,
      name: name,
      isAlive: isAlive,
      isDisconnected: isDisconnected,
    );
  }
}

extension SimpleModeResultEntityExtension on SimpleModeResultEntity {
  SimpleModeResultModel toModel() {
    return SimpleModeResultModel(
      rank: rank,
      id: id,
      name: name,
      isAlive: isAlive,
      isDisconnected: isDisconnected,
    );
  }
}

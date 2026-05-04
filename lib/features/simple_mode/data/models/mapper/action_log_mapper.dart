import 'package:boom_board/features/simple_mode/data/models/models/action_log_model.dart';
import 'package:boom_board/features/simple_mode/domain/entities/action_log_entity.dart';

extension ActionLogModelMapper on ActionLogModel {
  ActionLogEntity toEntity() {
    return ActionLogEntity(
      id: id,
      type: type,
      timestamp: timestamp,
      data: data,
    );
  }
}

extension ActionLogEntityMapper on ActionLogEntity {
  ActionLogModel toModel() {
    return ActionLogModel(
      id: id,
      type: type,
      timestamp: timestamp,
      data: data,
    );
  }
}

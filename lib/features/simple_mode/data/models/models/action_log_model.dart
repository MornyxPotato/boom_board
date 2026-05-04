import 'package:boom_board/features/simple_mode/data/models/enum/log_action_type.dart';

class ActionLogModel {
  final String id;
  final LogActionType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  ActionLogModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.data,
  });

  static ActionLogModel fromJson(Map<String, dynamic> json) {
    return ActionLogModel(
      id: json['id'],
      type: LogActionType.fromString(json['type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      data: json['data'],
    );
  }
}

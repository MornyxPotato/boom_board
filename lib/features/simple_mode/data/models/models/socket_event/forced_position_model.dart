import 'package:boom_board/core/data/models/coordinate.dart';

class ForcedPositionModel {
  Coordinate position;

  ForcedPositionModel({required this.position});

  static ForcedPositionModel fromJson(Map<String, dynamic> json) {
    return ForcedPositionModel(
      position: Coordinate.fromJson(json),
    );
  }
}

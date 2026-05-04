import 'package:boom_board/core/data/models/mapper/player_extension.dart';
import 'package:boom_board/core/data/models/requests/join_room_request.dart';
import 'package:boom_board/core/domain/entities/join_room_entity.dart';

extension SimpleModeJoinRoomExtension on JoinRoomResponse {
  JoinRoomEntity toEntity() {
    return JoinRoomEntity(
      roomCode: roomCode,
      gameMode: gameMode,
      hostId: hostId,
      playerList: playerList.map((e) => e.toEntity()).toList(),
    );
  }
}

extension JoinRoomEntityExtension on JoinRoomEntity {
  JoinRoomResponse toResponse() {
    return JoinRoomResponse(
      roomCode: roomCode,
      gameMode: gameMode,
      hostId: hostId,
      playerList: playerList.map((e) => e.toModel()).toList(),
    );
  }
}

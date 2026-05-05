class ThrowBombRequest {
  final String roomCode;
  final int x;
  final int y;

  ThrowBombRequest({
    required this.roomCode,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'x': x,
      'y': y,
    };
  }
}

class ThrowBombResponse {
  final int throwOrder;

  ThrowBombResponse({required this.throwOrder});

  static ThrowBombResponse fromJson(Map<String, dynamic> json) {
    return ThrowBombResponse(throwOrder: json['throwOrder']);
  }
}

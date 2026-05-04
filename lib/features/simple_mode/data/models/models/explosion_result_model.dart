class ExplosionResultModel {
  final String bomberId;
  final String? victimId;
  final bool isHit;
  final int x;
  final int y;

  ExplosionResultModel({
    required this.bomberId,
    required this.isHit,
    required this.x,
    required this.y,
    this.victimId,
  });

  static ExplosionResultModel fromJson(Map<String, dynamic> json) {
    return ExplosionResultModel(
      bomberId: json['bomberId'],
      victimId: json['victimId'],
      isHit: json['isHit'],
      x: json['x'],
      y: json['y'],
    );
  }
}

class PlayerModel {
  String id;
  String name;
  bool isAlive;
  bool hasPositioned;
  bool isDisconnected;

  PlayerModel({
    required this.id,
    required this.name,
    required this.isAlive,
    required this.hasPositioned,
    required this.isDisconnected,
  });

  static PlayerModel fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
      isAlive: json['isAlive'],
      hasPositioned: json['hasPositioned'],
      isDisconnected: json['isDisconnected'],
    );
  }
}

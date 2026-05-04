class PlayerEntity {
  String id;
  String name;
  bool isAlive;
  bool hasPositioned;
  bool isDisconnected;

  PlayerEntity({
    required this.id,
    required this.name,
    required this.isAlive,
    required this.hasPositioned,
    required this.isDisconnected,
  });
}

class SimpleModeResultEntity {
  final int rank;
  final String id;
  final String name;
  final bool isAlive;
  final bool isDisconnected;

  SimpleModeResultEntity({
    required this.rank,
    required this.id,
    required this.name,
    required this.isAlive,
    required this.isDisconnected,
  });

  @override
  String toString() {
    return 'SimpleModeResultEntity rank: $rank, id: $id, name: $name, isAlive: $isAlive, isDisconnected: $isDisconnected';
  }
}

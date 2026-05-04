class SimpleModeResultEntity {
  final int rank;
  final String name;
  final bool isAlive;

  SimpleModeResultEntity({
    required this.rank,
    required this.name,
    required this.isAlive,
  });

  @override
  String toString() {
    return 'SimpleModeResultEntity rank: $rank, name: $name, isAlive: $isAlive';
  }
}

class SimpleModeResultModel {
  final int rank;
  final String id;
  final String name;
  final bool isAlive;
  final bool isDisconnected;

  SimpleModeResultModel({
    required this.rank,
    required this.id,
    required this.name,
    required this.isAlive,
    required this.isDisconnected,
  });

  static SimpleModeResultModel fromJson(Map<String, dynamic> json) {
    return SimpleModeResultModel(
      rank: json['rank'],
      id: json['id'],
      name: json['name'],
      isAlive: json['isAlive'],
      isDisconnected: json['isDisconnected'],
    );
  }
}

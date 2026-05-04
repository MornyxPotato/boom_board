class SimpleModeResultModel {
  final int rank;
  final String name;
  final bool isAlive;

  SimpleModeResultModel({
    required this.rank,
    required this.name,
    required this.isAlive,
  });

  static SimpleModeResultModel fromJson(Map<String, dynamic> json) {
    return SimpleModeResultModel(
      rank: json['rank'],
      name: json['name'],
      isAlive: json['isAlive'],
    );
  }
}

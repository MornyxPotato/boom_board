class SimpleModePlayerEntity {
  final String id;
  final String name;
  final bool isAlive;
  final bool hasPositioned;
  final bool hasThrowBomb;
  final bool isDisconnected;
  final int? x;
  final int? y;
  final int? throwOrder;

  SimpleModePlayerEntity({
    required this.id,
    required this.name,
    required this.isAlive,
    required this.hasPositioned,
    required this.hasThrowBomb,
    required this.isDisconnected,
    this.x,
    this.y,
    this.throwOrder,
  });

  SimpleModePlayerEntity copyWith({
    String? id,
    String? name,
    bool? isAlive,
    bool? hasPositioned,
    bool? hasThrowBomb,
    bool? isDisconnected,
    int? x,
    int? y,
    int? throwOrder,
    bool clearThrowOrder = false,
  }) {
    return SimpleModePlayerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isAlive: isAlive ?? this.isAlive,
      hasPositioned: hasPositioned ?? this.hasPositioned,
      hasThrowBomb: hasThrowBomb ?? this.hasThrowBomb,
      isDisconnected: isDisconnected ?? this.isDisconnected,
      x: x ?? this.x,
      y: y ?? this.y,
      throwOrder: clearThrowOrder ? null : (throwOrder ?? this.throwOrder),
    );
  }

  @override
  String toString() {
    return 'SimpleModePlayerEntity id: $id, name: $name, isAlive: $isAlive, hasPosition: $hasPositioned, hasThrowBomb: $hasThrowBomb, isDisconnected: $isDisconnected, x: $x, y: $y, throwOrder: $throwOrder';
  }
}

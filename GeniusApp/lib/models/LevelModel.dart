class Level {
  final int id;
  final String name;

  const Level({
    this.id,
    this.name,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
    );
  }
}

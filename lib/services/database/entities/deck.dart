class Deck {
  final int id;
  final String name;

  Deck({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    final id = map["id"] as int;
    final name = map["name"] as String;

    return Deck(id: id, name: name);
  }

  @override
  String toString() {
    final map = toMap();
    return 'Deck($map)';
  }
}

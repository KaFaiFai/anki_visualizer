class Notetype {
  final int id;
  final String name;

  Notetype({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory Notetype.fromMap(Map<String, dynamic> map) {
    final id = map["id"] as int;
    final name = map["name"] as String;

    return Notetype(id: id, name: name);
  }

  @override
  String toString() {
    final map = toMap();
    return 'Notetype($map)';
  }
}

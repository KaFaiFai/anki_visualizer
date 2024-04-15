class Field {
  final int ntid;
  final int ord;
  final String name;

  Field({
    required this.ntid,
    required this.ord,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      "ntid": ntid,
      "ord": ord,
      "name": name,
    };
  }

  factory Field.fromMap(Map<String, dynamic> map) {
    final ntid = map["ntid"] as int;
    final ord = map["ord"] as int;
    final name = map["name"] as String;

    return Field(ntid: ntid, ord: ord, name: name);
  }

  @override
  String toString() {
    final map = toMap();
    return "Field($map)";
  }
}

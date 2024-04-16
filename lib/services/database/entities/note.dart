class Note {
  final int id;
  final int mid;
  final String flds;
  final int sfld;

  Note({
    required this.id,
    required this.mid,
    required this.flds,
    required this.sfld,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "mid": mid,
      "flds": flds,
      "sfld": sfld,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    final id = map["id"] as int;
    final mid = map["mid"] as int;
    final flds = map["flds"] as String;
    final sfld = map["sfld"] as int;

    return Note(id: id, mid: mid, flds: flds, sfld: sfld);
  }

  @override
  String toString() {
    final map = toMap();
    return 'Notes($map)';
  }
}

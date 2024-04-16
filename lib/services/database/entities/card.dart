class Card {
  final int id;
  final int nid;
  final int did;
  final int ord;
  final int type;
  final int queue;
  final int ivl;
  final int factor;
  final int reps;
  final int lapses;
  final int left;

  Card({
    required this.id,
    required this.nid,
    required this.did,
    required this.ord,
    required this.type,
    required this.queue,
    required this.ivl,
    required this.factor,
    required this.reps,
    required this.lapses,
    required this.left,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nid": nid,
      "did": did,
      "ord": ord,
      "type": type,
      "queue": queue,
      "ivl": ivl,
      "factor": factor,
      "reps": reps,
      "lapses": lapses,
      "left": left,
    };
  }

  factory Card.fromMap(Map<String, dynamic> map) {
    final id = map["id"] as int;
    final nid = map["nid"] as int;
    final did = map["did"] as int;
    final ord = map["ord"] as int;
    final type = map["type"] as int;
    final queue = map["queue"] as int;
    final ivl = map["ivl"] as int;
    final factor = map["factor"] as int;
    final reps = map["reps"] as int;
    final lapses = map["lapses"] as int;
    final left = map["left"] as int;

    return Card(
      id: id,
      nid: nid,
      did: did,
      ord: ord,
      type: type,
      queue: queue,
      ivl: ivl,
      factor: factor,
      reps: reps,
      lapses: lapses,
      left: left,
    );
  }

  @override
  String toString() {
    final map = toMap();
    return 'Cards($map)';
  }
}

class Review {
  final int id;
  final int cid;
  final int ease;
  final int ivl;
  final int lastIvl;
  final int time;
  final int type;

  Review({
    required this.id,
    required this.cid,
    required this.ease,
    required this.ivl,
    required this.lastIvl,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "cid": cid,
      "ease": ease,
      "ivl": ivl,
      "lastIvl": lastIvl,
      "time": time,
      "type": type,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    final id = map["id"] as int;
    final cid = map["cid"] as int;
    final ease = map["ease"] as int;
    final ivl = map["ivl"] as int;
    final lastIvl = map["lastIvl"] as int;
    final time = map["time"] as int;
    final type = map["type"] as int;

    return Review(id: id, cid: cid, ease: ease, ivl: ivl, lastIvl: lastIvl, time: time, type: type);
  }

  @override
  String toString() {
    final map = toMap();
    return "Review($map)";
  }
}

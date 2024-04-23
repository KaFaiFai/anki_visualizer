extension FutureExtension<T> on Future<T> {
  Future<T> delayed([Duration duration = const Duration(seconds: 1)]) {
    // to simulate when the process is long
    return Future.delayed(duration, () => this);
  }
}

extension IntExtension on int {
  int roundTo(int nearest) {
    return (this / nearest).round() * nearest;
  }
}

extension FutureExtension<T> on Future<T> {
  Future<T> delayed([Duration duration = const Duration(seconds: 1)]) {
    // to simulate when the process is long
    return Future.delayed(const Duration(seconds: 3), () => this);
  }
}

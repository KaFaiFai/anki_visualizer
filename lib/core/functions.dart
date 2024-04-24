String? validatePositiveInteger(String? value) {
  if (value == null) {
    return "Please enter something";
  } else {
    final num = int.tryParse(value);
    if (num == null || num <= 0) {
      return "Must be a positive integer";
    }
  }
  return null;
}

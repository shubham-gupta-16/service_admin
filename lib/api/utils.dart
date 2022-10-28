extension StringExtNullable on String? {
  String? decode() {
    if (this == null) return null;
    return Uri.decodeFull(this!);
  }

  String? encode() {
    if (this == null) return null;
    return Uri.encodeFull(this!);
  }
}

extension StringExt on String {
  String decode() {
    return Uri.decodeFull(this);
  }

  String encode() {
    return Uri.encodeFull(this);
  }
}

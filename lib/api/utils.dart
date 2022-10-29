extension StringExtNullable on String? {
  String? decode() {
    if (this == null) return null;
    return this!.decode();
  }

  String? encode() {
    if (this == null) return null;
    return this!.encode();
  }
}

extension StringExt on String {
  String decode() {
    try {
      return Uri.decodeFull(this);
    } catch (e){
      print(this);
      print(e);
      return this;
    }
  }

  String encode() {
    return Uri.encodeFull(this);
  }
}

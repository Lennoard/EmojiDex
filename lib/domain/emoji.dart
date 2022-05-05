import 'dart:collection';

class Emoji {
  final int id;
  final String name;
  final String emoji;
  final String unicode;
  final LinkedHashMap<String, dynamic> category;
  final LinkedHashMap<String, dynamic> subCategory;
  final List<dynamic> children;

  Emoji(this.id, this.name, this.emoji, this.unicode, this.category,
      this.subCategory, this.children);

  @override
  String toString() {
    return emoji;
  }
}

import '../domain/emoji.dart';

class EmojiMapper {
  Emoji map(Map<String, dynamic> json) {
    return Emoji(
        json['id'],
        json['name'],
        json['emoji'],
        json['unicode'],
        json['category'],
        json['sub_category'],
        json['children'],
    );
  }

  Map<String, dynamic> unmap(Emoji emoji) {
    return {
      'id': emoji.id,
      'name': emoji.name,
      'emoji': emoji.emoji,
      'unicode': emoji.unicode,
      'category': emoji.category,
      'sub_category': emoji.subCategory,
      'children': emoji.children,
    };
  }
}

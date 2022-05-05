import 'package:emoji_dex/domain/emoji.dart';

abstract class EmojiRepository {
   Future<List<Emoji>> getRandomEmojis();
   Future<List<Emoji>> getEmojis(int limit);
   Future<List<Emoji>> search(
       String query, int? limit,
       List<int>? categories,
       List<int>? subCategories
   );
}

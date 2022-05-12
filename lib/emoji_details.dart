import 'package:emoji_dex/domain/emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmojiDetailsPage extends StatefulWidget {
  const EmojiDetailsPage({Key? key}) : super(key: key);

  static const String routeName = '/details';

  @override
  State<EmojiDetailsPage> createState() => _EmojiDetailsPageState();
}

class _EmojiDetailsPageState extends State<EmojiDetailsPage> {
  static const String keyPrefFavoriteIds = 'favorites';
  Set<int> favoriteIds = Set();

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(keyPrefFavoriteIds);
    if (items == null) return;

    setState(() {
      favoriteIds.addAll(items.map((e) => int.parse(e)));
    });
  }

  Future<void> toggleLike(Emoji emoji) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bool canAdd = favoriteIds.add(emoji.id);
      if (!canAdd) {
        favoriteIds.remove(emoji.id);
      }

      prefs.setStringList(
          keyPrefFavoriteIds, favoriteIds.map((e) => e.toString()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    Emoji emoji = ModalRoute.of(context)?.settings.arguments as Emoji;
    var color =
        favoriteIds.contains(emoji.id) ? Colors.red.shade800 : Colors.black38;
    var icon =
        favoriteIds.contains(emoji.id) ? Icons.favorite : Icons.favorite_border;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Favorito', style: TextStyle(color: color)),
        isExtended: true,
        backgroundColor: Colors.red.shade50,
        icon: Icon(icon, color: color),
        onPressed: () {
          toggleLike(emoji);
        },
      ),
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 240,
            color: Colors.blueGrey.shade900,
            child: Center(
              child: InkWell(
                child: Text(
                  emoji.emoji,
                  style: const TextStyle(fontSize: 128),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: emoji.emoji));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Copiado para a área de transferência')));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              emoji.name,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ID: ${emoji.id}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Unicode: ${emoji.unicode}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Category: ${emoji.category['name']}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Subcategory: ${emoji.subCategory['name']}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}

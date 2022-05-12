import 'package:emoji_dex/data/emoji_mapper.dart';
import 'package:emoji_dex/data/emoji_repository_impl.dart';
import 'package:emoji_dex/domain/emoji.dart';
import 'package:emoji_dex/domain/emoji_repository.dart';
import 'package:emoji_dex/domain/get_response_use_case.dart';
import 'package:emoji_dex/emoji_details.dart';
import 'package:emoji_dex/search/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const EmojiDex());
}

class EmojiDex extends StatelessWidget {
  const EmojiDex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emojis',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        EmojiDetailsPage.routeName: (context) => const EmojiDetailsPage()
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const pageSize = 20;
  static const String keyPrefFavoriteIds = 'favorites';
  Set<int> favoriteIds = {};
  late Future<List<Emoji>> emojis;
  final EmojiRepository _postsRepository =
      EmojiRepositoryImpl(EmojiMapper(), GetResponseUseCase());
  final PagingController<int, Emoji> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
    loadPrefs();
    emojis = _postsRepository.getRandomEmojis();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _postsRepository.getEmojis(pageKey);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade700,
      appBar: AppBar(
        title: const Text('EmojiDex'),
        backgroundColor: Colors.blueGrey.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
          )
        ],
      ),
      body: PagedListView<int, Emoji>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Emoji>(
          itemBuilder: (context, item, index) {
            return GestureDetector(
              child: buildListItem(item),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EmojiDetailsPage.routeName, arguments: item);
              },
            );
          },
        ),
        separatorBuilder: (context, index) => const Spacer(),
      ),
    );
  }

  ListView buildList(List<Emoji>? emojis) {
    if (emojis == null) return ListView();
    return ListView(
      children: emojis.map((e) => buildListItem(e)).toList(),
    );
  }

  Card buildListItem(Emoji emoji) {
    var color =
    favoriteIds.contains(emoji.id) ? Colors.yellow.shade800 : Colors.white38;

    return Card(
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white24, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(emoji.toString()),
        subtitle: Text(emoji.name),
        trailing: Icon(
          favoriteIds.contains(emoji.id) ? Icons.favorite : Icons.favorite_border,
          color: color,
        ),
        textColor: Colors.white,
      ),
    );
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList(keyPrefFavoriteIds);
    if (items == null) return;

    setState(() {
      favoriteIds.addAll(items.map((e) => int.parse(e)));
    });
  }
}

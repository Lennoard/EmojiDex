import 'package:emoji_dex/data/emoji_mapper.dart';
import 'package:emoji_dex/data/emoji_repository_impl.dart';
import 'package:emoji_dex/domain/emoji.dart';
import 'package:emoji_dex/domain/emoji_repository.dart';
import 'package:emoji_dex/domain/get_response_use_case.dart';
import 'package:emoji_dex/emoji_details.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
      ),
      body: PagedListView<int, Emoji>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Emoji>(
          itemBuilder: (context, item, index) => GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EmojiDetailsPage.routeName, arguments: item);
              },
              child: buildListItem(item)),
        ),
        separatorBuilder: (context, index) => const Spacer(),
      ),
    );
  }

  ListView buildList(List<Emoji>? posts) {
    if (posts == null) return ListView();
    return ListView(
      children: posts.map((e) => buildListItem(e)).toList(),
    );
  }

  Card buildListItem(Emoji emoji) {
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
        trailing: Text("ID: ${emoji.id}"),
        textColor: Colors.white,
      ),
    );
  }
}

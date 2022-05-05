import 'package:emoji_dex/domain/emoji.dart';
import 'package:flutter/material.dart';

class EmojiDetailsPage extends StatefulWidget {
  const EmojiDetailsPage({Key? key}) : super(key: key);

  static const String routeName = '/details';

  @override
  State<EmojiDetailsPage> createState() => _EmojiDetailsPageState();
}

class _EmojiDetailsPageState extends State<EmojiDetailsPage> {

  @override
  Widget build(BuildContext context) {
    Emoji emoji = ModalRoute.of(context)?.settings.arguments as Emoji;
    return Scaffold(
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
              child: Text(
                emoji.emoji,
                style: const TextStyle(fontSize: 128),
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

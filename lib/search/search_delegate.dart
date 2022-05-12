import 'package:emoji_dex/domain/emoji.dart';
import 'package:flutter/material.dart';

import '../data/emoji_mapper.dart';
import '../data/emoji_repository_impl.dart';
import '../domain/emoji_repository.dart';
import '../domain/get_response_use_case.dart';
import '../emoji_details.dart';

class MySearchDelegate extends SearchDelegate {
  final EmojiRepository _postsRepository =
      EmojiRepositoryImpl(EmojiMapper(), GetResponseUseCase());

  final List<Emoji> results = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade400,
      child: FutureBuilder(
        future: _performSearch(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.separated(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                var emoji = results[index];
                return ListTile(
                  title: Text(emoji.toString()),
                  subtitle: Text(emoji.name),
                  trailing: Text("ID: ${emoji.id}"),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(EmojiDetailsPage.routeName, arguments: emoji);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }
        },
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.blueGrey.shade800,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.blueGrey.shade800),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white),
        titleMedium: const TextStyle(color: Colors.white),
        titleSmall: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = _searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return Container(
      color: Colors.blueGrey.shade400,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        },
      ),
    );
  }

  _performSearch() async {
    var emojis = await _postsRepository.search(query, null);
    results.clear();
    results.addAll(emojis);
    return emojis;
  }

  final List<String> _searchResults = [
    'baby',
    'happy',
    'flag',
    'person',
    'moon',
  ];
}

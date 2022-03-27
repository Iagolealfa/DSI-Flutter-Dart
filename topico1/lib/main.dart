// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// #docregion MyApp
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
  // #enddocregion build
}

// #enddocregion MyApp

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #enddocregion RWS-var

  void remove(x) {
    setState(() {
      _saved.remove(x);
      _suggestions.remove(x);
      print(_suggestions);
    });
  }

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
          ],
        ),
        // #docregion itemBuilder
        body: GridView.builder(
          itemCount: 100000,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 80 / 10,
            crossAxisCount: 2,
          ),
          itemBuilder: /*1*/ (context, i) {
            final index = i ~/ 2; /*3*/
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10)); /*4*/
            }

            final alreadySaved = _saved.contains(_suggestions[index]);

            // #docregion listTile
            return Dismissible(
              child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      _suggestions[index].asPascalCase,
                      style: _biggerFont,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null,
                        semanticLabel:
                            alreadySaved ? 'Remove from saved' : 'Save',
                      ),
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions[index]);
                          } else {
                            _saved.add(_suggestions[index]);
                          }
                        });
                      },
                    ),
                  )),
              key: Key(_suggestions[index].asPascalCase),
              background: Container(
                color: Colors.red.withOpacity(0.4),
              ),
              onDismissed: (direction) {
                remove(_suggestions[index]);
              },
            );
            // #enddocregion listTile
          },
        ));
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  // #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

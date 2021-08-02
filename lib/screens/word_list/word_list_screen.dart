import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget {
  static const String routeName = '/wordList';
  const WordListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Word List'),
    );
  }
}

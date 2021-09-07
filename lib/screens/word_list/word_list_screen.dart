import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/screens/word_list/widgets/widgets.dart';

import 'bloc/wordlist_bloc.dart';

class WordListScreen extends StatelessWidget {
  static const String routeName = '/wordList';
  const WordListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('字彙列表'),
        centerTitle: true,
      ),
      body: BlocConsumer<WordlistBloc, WordlistState>(
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.status) {
            // 載入中
            case WordlistStateStatus.loading:
              return CircularProgressIndicator();
              break;
            // 預設顯示資料
            default:
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 20.0,
                ),
                child: ListView.builder(
                  itemCount: state.currentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Vocabulary vocabulary = state.currentList[index];
                    return VocabularyTile(vocabulary: vocabulary);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

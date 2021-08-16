import 'package:flutter/material.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/screens/detail/widgets/widgets.dart';

// TabBar View
class DetailTabBarView extends StatelessWidget {
  const DetailTabBarView({
    Key key,
    @required this.sentenceBundle,
  }) : super(key: key);
  final SentenceBundle sentenceBundle;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        // 1. 必考字彙
        // ListView的padding，每個tab都要一樣
        // 也跟上面句子容器的左右padding(25.0)一樣，看起來會比較整齊
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
          child: ListView.builder(
            itemCount: sentenceBundle.vocabularies.length,
            itemBuilder: (context, index) {
              Vocabulary vocabulary = sentenceBundle.vocabularies[index];
              return VocTile(
                sentenceId: vocabulary.sentenceId,
                vocabularyId: vocabulary.vocabularyId,
                voc: vocabulary.voc,
                category: vocabulary.category,
                chinese: vocabulary.chinese,
              );
            },
          ),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Text("字彙解析"),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Text("文法解析"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:toeicking2021/models/models.dart';

import '../../screens.dart';

class VocabularyTile extends StatelessWidget {
  final Vocabulary vocabulary;
  const VocabularyTile({
    Key key,
    @required this.vocabulary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              // 萬一文字多行時是對齊上方的
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 字彙
                Text(
                  vocabulary.voc,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 8.0),
                // 詞性
                Text(
                  '(${vocabulary.category}.)',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 8.0),
                // 要使用TextOverflow.ellipsis，Text()必須有一個寬度，兩個方法：
                // 1. 外包Container()給寬度
                // 2. 外包Expanded()
                Expanded(
                  child: Text(
                    vocabulary.chinese,
                    style: TextStyle(fontSize: 18.0, fontFamily: 'Noto'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                // 進入Detaile頁面
                DetailScreen.routeName,
                arguments: DetailScreenArgs(
                  fromWordList: true,
                  sentenceId: vocabulary.sentenceId,
                ),
              );
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
          // 點按ListTile
          onTap: () {},
        ),
      ),
    );
  }
}

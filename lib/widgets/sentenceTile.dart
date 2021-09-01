import 'package:flutter/material.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/screens/detail/detail_screen.dart';

class SentenceTile extends StatelessWidget {
  final SentenceBundle sentenceBundle;
  const SentenceTile({
    Key key,
    @required this.sentenceBundle,
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
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              // 讓文字放在CircleAvatar()裡很整齊
              child: FittedBox(
                child: Text('${sentenceBundle.sentence.sentenceId.toString()}'),
              ),
            ),
          ),
          title: Text('${sentenceBundle.sentence.sen}'),
          subtitle: Text('${sentenceBundle.sentence.chinesese}'),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                // 進入Detaile頁面
                DetailScreen.routeName,
                arguments: DetailScreenArgs(
                  sentenceBundle: sentenceBundle,
                  fromWordList: false,
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

import 'package:flutter/material.dart';
import 'package:toeicking2021/models/models.dart';
// 句子與翻譯
class DetailSentenceContainer extends StatelessWidget {
  const DetailSentenceContainer({
    Key key,
    @required this.sentenceBundle,
  }) : super(key: key);

  final SentenceBundle sentenceBundle;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 25.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sentenceBundle.sentence.sen,
            // Theme.of(context).textTheme.headline6
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 10.0),
          Text(
            sentenceBundle.sentence.chinesese,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              letterSpacing: 1.0,
              fontFamily: 'Noto',
            ),
          )
        ],
      ),
    );
  }
}
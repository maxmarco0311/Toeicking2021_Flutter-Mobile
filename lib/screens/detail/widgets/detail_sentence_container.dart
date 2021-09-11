import 'package:flutter/material.dart';
import 'package:toeicking2021/models/models.dart';

// 句子與翻譯
class DetailSentenceContainer extends StatefulWidget {
  const DetailSentenceContainer({
    Key key,
    @required this.sentenceBundle,
    @required this.showSentence,
  }) : super(key: key);

  final SentenceBundle sentenceBundle;
  final bool showSentence;

  @override
  _DetailSentenceContainerState createState() =>
      _DetailSentenceContainerState();
}

class _DetailSentenceContainerState extends State<DetailSentenceContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.showSentence
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sentenceBundle.sentence.sen,
                      // Theme.of(context).textTheme.headline6
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.sentenceBundle.sentence.chinesese,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontFamily: 'Noto',
                      ),
                    )
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sentenceBundle.sentence.sen,
                      // 只顯示一行
                      maxLines: 1,
                      // 多的字切掉
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

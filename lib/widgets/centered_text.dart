import 'package:flutter/material.dart';

// 置中文字的自訂widget
class CenteredText extends StatelessWidget {
  final String text;

  const CenteredText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16.0),
          // 文字水平置中
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
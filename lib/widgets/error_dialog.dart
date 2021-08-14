import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 客製化對應裝置平台的錯誤訊息Dialogue的自訂widget
class ErrorDialog extends StatelessWidget {
  // 標題
  final String title;
  // 錯誤code
  // final String code;
  // 內容
  final String content;

  const ErrorDialog({
    Key key,
    // title用預設值，因為每次都一樣
    this.title = '錯誤訊息',
    // content每次都一樣，必備屬性
    @required this.content,
    // @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 判斷裝置平台
    return Platform.isIOS
        // 自訂方法顯示Dialogue，需要BuildContext
        ? _showIOSDialog(context)
        : _showAndroidDialog(context);
  }

  // 回傳CupertinoAlertDialog
  CupertinoAlertDialog _showIOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      // 標題
      title: Icon(
        Icons.error,
        color: Theme.of(context).primaryColor,
        size: 60.0,
      ),
      // 內容
      content: Text(content),
      // 按鈕(Action)
      actions: [
        CupertinoDialogAction(
          // 點按後將Dialogue關掉要用pop()
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }

  // 回傳AlertDialog
  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      // 標題
      title: Icon(
        Icons.error,
        color: Theme.of(context).primaryColor,
        size: 60.0,
      ),
      // 內容
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 18.0, letterSpacing: 1.0),
          ),
        ],
      ),
      // 按鈕(Action)
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertButton(
              backgroundColor: Theme.of(context).primaryColor,
              edgeInset: EdgeInsets.symmetric(horizontal: 8.0),
              text: '關閉',
              fontSize: 16.0,
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ],
    );
  }
}

class AlertButton extends StatelessWidget {
  final Color backgroundColor;
  final EdgeInsetsGeometry edgeInset;
  final String text;
  final double fontSize;
  final Function onPressed;
  const AlertButton({
    Key key,
    @required this.backgroundColor,
    @required this.edgeInset,
    @required this.text,
    @required this.fontSize,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        onPrimary: Colors.white,
      ),
      child: Padding(
        padding: edgeInset,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, letterSpacing: 1.0),
        ),
      ),
    );
  }
}

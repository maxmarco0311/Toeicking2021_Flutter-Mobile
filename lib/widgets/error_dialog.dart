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
      title: Text(title),
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
      title: Text(title),
      // 內容
      content: Text(content),
      // 按鈕(Action)
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }
}

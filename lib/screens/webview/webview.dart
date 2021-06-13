import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/screens/screens.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  static const String routeName = '/webview';
  static Route route() {
    // MaterialPageRoute()有兩個常見的屬性：
    // 1. settings-->屬性值型別為RouteSettings()，可設routeName和傳送參數(物件型別)
    // 2. builder-->屬性值型別為WidgetBuilder，回傳screen widget
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => WebviewScreen(),
    );
  }

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  num position = 1;
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  WebViewController _controller;
  @override
  void initState() {
    super.initState();
    // 此行設定，鍵盤才會正常
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 取得目前url
        String url = await _controller.currentUrl();
        // 判斷是否為最初開啟webview的url
        if (url == 'https://google.com') {
          // 是的話回到"App的上一頁"
          // 回去之前先reload user，有驗證的會導向nav_screen，沒驗證還是回到verification_screen
          context.read<AuthRepository>().getCurrentUser.reload();
          return true;
        } else {
          // 不是的話回到"webview的上一頁"
          _controller.goBack();
          return false;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              // 隱藏回上一頁
              automaticallyImplyLeading: false,
              title: Text('前去收信'),
              actions: [
                // x按鈕
                IconButton(
                  onPressed: () {
                    // reload()會觸發userChanges()，若有驗證，emailVerified會是true
                    context.read<AuthRepository>().getCurrentUser.reload();
                    // 導回splash_screen，有驗證的會導向nav_screen，沒驗證還是回到verification_screen
                    Navigator.of(context).pushNamed(SplashScreen.routeName);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            body: IndexedStack(
              index: position,
              children: [
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: 'https://google.com',
                  onWebViewCreated: (WebViewController webViewController) {
                    // _controller.complete(webViewController);
                    _controller = webViewController;
                  },
                  onPageStarted: (value) {
                    setState(() {
                      position = 1;
                    });
                  },
                  onPageFinished: (value) {
                    setState(() {
                      position = 0;
                    });
                  },
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

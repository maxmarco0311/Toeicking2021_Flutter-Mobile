import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
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
  // position預設為1，一進入頁面預設是顯示CircularProgressIndicator()
  num position = 1;
  // 移動上下頁所需要的controller
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // 控制flush bar只在進入webview第一頁顯示
  bool showFlushBar = true;
  @override
  void initState() {
    super.initState();
    // 此行設定，鍵盤才會正常
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: // x按鈕
                TextButton(
              // 打開bottom sheet
              onPressed: () {
                // reload()會觸發userChanges()，若有驗證，emailVerified會是true
                context.read<AuthRepository>().getCurrentUser.reload();
                // 導回splash_screen，有驗證的會導向nav_screen，沒驗證還是回到verification_screen
                Navigator.of(context).pushNamed(SplashScreen.routeName);
              },
              child: Text(
                '完成',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  primary: Colors.white),
            ),
            //     IconButton(
            //   onPressed: () {
            //     // reload()會觸發userChanges()，若有驗證，emailVerified會是true
            //     context.read<AuthRepository>().getCurrentUser.reload();
            //     // 導回splash_screen，有驗證的會導向nav_screen，沒驗證還是回到verification_screen
            //     Navigator.of(context).pushNamed(SplashScreen.routeName);
            //   },
            //   icon: Icon(
            //     Icons.close,
            //     size: 30.0,
            //   ),
            // ),
            title: Text('信箱驗證'),
            centerTitle: true,
            // 隱藏回上一頁
            automaticallyImplyLeading: false,
            actions: [
              // 網頁移動(上一頁/下一頁)
              NavigationControls(_controller.future),
            ],
          ),
          // IndexedStack()是根據index決定顯示哪一個child widget的stack widget
          body: IndexedStack(
            // 必備屬性，屬性值position為int，position值為哪個就顯示哪個child widget
            index: position,
            children: [
              // index為0的child widget
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'https://google.com',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                  // _controller = webViewController;
                },
                // 頁面開始加載
                onPageStarted: (value) {
                  setState(() {
                    // 顯示CircularProgressIndicator()
                    position = 1;
                  });
                },
                // 頁面加載完畢
                onPageFinished: (value) {
                  setState(() {
                    // 顯示webview
                    position = 0;
                  });
                  // 顯示FlushBar
                  if (showFlushBar) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      duration: Duration(seconds: 7),
                      icon: Icon(
                        Icons.notifications,
                        size: 32.0,
                        color: Colors.white,
                      ),
                      title: '信箱驗證',
                      message: '請至maxmarco0311@gmail.com收驗證信，完成註冊程序',
                      // mainButton: FlatButton(
                      //   child: Text(
                      //     '關閉',
                      //     style: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      //   onPressed: () => Flushbar().dismiss(),
                      // ),
                      // 還有margin屬性可決定flushbar的位置
                    )..show(context);
                    // 顯示一次後就不顯示
                    showFlushBar = false;
                  }
                },
              ),
              // index為1的child widget
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 上下頁widget
class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);
  // : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("無上一頁")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("無下一頁")),
                        );
                        return;
                      }
                    },
            ),
            // IconButton(
            //   icon: const Icon(Icons.replay),
            //   onPressed: !webViewReady
            //       ? null
            //       : () {
            //           controller.reload();
            //         },
            // ),
          ],
        );
      },
    );
  }
}

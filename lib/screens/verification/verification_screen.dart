import 'package:flutter/material.dart';
import 'package:toeicking2021/widgets/widgets.dart';

import '../screens.dart';

// 路由參數物件
class VerificationScreenArgs {
  final email;

  const VerificationScreenArgs({@required this.email});
}

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';

  final email;

  const VerificationScreen({
    Key key,
    @required this.email,
  }) : super(key: key);
  // 此方法回傳的Route物件，其實就是代表一個screen的抽象物件
  // 常見的子類別有MaterialPageRoute()或PageRouteBuilder()
  // 兩者都要在builder的callback函式中回傳Screen()
  // 此方法是用在onGenerateRoute的callback函式中
  static Route route({@required VerificationScreenArgs args}) {
    // MaterialPageRoute()有兩個常見的屬性：
    // 1. settings-->屬性值型別為RouteSettings()，可設routeName和傳送參數(物件型別)
    // 2. builder-->屬性值型別為WidgetBuilder，回傳screen widget
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => VerificationScreen(email: args.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('註冊結果'),
          centerTitle: true,
          // 隱藏回上一頁
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                // 導向Login Screen.
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              icon: Icon(
                Icons.home,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CenteredText(
                text: '您好，已寄送註冊驗證信至$email，請前往收信完成註冊程序。',
              ),
              SizedBox(
                height: 10.0,
              ),
              // 打開webview
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(WebviewScreen.routeName),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '前去收信',
                    style: TextStyle(fontSize: 17.0, letterSpacing: 1.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

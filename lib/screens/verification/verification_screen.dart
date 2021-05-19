import 'package:flutter/material.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';
  // 此方法回傳的Route物件，其實就是代表一個screen的抽象物件
  // 常見的子類別有MaterialPageRoute()或PageRouteBuilder()
  // 兩者都要在builder的callback函式中回傳Screen()
  // 此方法是用在onGenerateRoute的callback函式中
  static Route route() {
    // MaterialPageRoute()有兩個常見的屬性：
    // 1. settings-->屬性值型別為RouteSettings()，可設routeName和傳送參數(物件型別)
    // 2. builder-->屬性值型別為WidgetBuilder，回傳screen widget
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => VerificationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final email = routeArgs['email'];
    return CenteredText(
      text: '您好，已寄送驗證信至$email，請前往收信完成驗證程序，謝謝。',
    );
  }
}

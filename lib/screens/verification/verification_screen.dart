import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/repositories/auth/auth_repositories.dart';
import 'package:toeicking2021/widgets/custom_elevated_button.dart';
import 'package:toeicking2021/widgets/widgets.dart';

import '../screens.dart';

// 路由參數物件
class VerificationScreenArgs {
  final email;
  // final BuildContext passedContext;

  const VerificationScreenArgs({
    @required this.email,
    // @required this.passedContext,
  });
}

class VerificationScreen extends StatelessWidget {
  static const String routeName = '/verification';

  final email;
  // final BuildContext passedContext;

  const VerificationScreen({
    Key key,
    @required this.email,
    // @required this.passedContext,
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
      builder: (_) => VerificationScreen(
        email: args.email,
        // passedContext: args.passedContext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('寄出驗證信'),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '請至$email收信完成註冊程序',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomElevatedButton(
                    text: '前往收信',
                    onPressed: () {
                      // 打開webview
                      Navigator.of(context).pushNamed(WebviewScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

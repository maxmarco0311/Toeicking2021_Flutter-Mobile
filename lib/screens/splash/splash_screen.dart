import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/screens/screens.dart';
import 'package:toeicking2021/services/dynamic_links_service.dart';

// StatefulWidget在build()方法外可以取到BuildContext context(initState()除外)
class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
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
      builder: (_) => SplashScreen(),
    );
  }

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(
        const Duration(milliseconds: 1000),
        () => _dynamicLinkService.retrieveDynamicLink(context),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // iOS不可以滑回上頁，Andriod沒有上一頁箭頭，很重要!
      onWillPop: () async => false,
      // BlocListener是用在針對狀態改變"執行功能"，而非渲染UI
      // ***在這裡註冊AuthBloc***
      // 若用BlocListener，導向時listener屬性值函式會被呼叫不只一次，所以頁面會閃兩次
      // 改用BlocConsumer，導向時listener屬性值函式只會被呼叫一次，所以頁面正常
      child: BlocConsumer<AuthBloc, AuthState>(
        // (用BlocListener時)如果AuthChanged狀態不變，就不要觸發BlocListener的寫法如下：
        // listenWhen: (prevState, state) => prevState.status != state.status,
        // ***問題是開發測試時，沒有進入nav，無法logout，所以按按鈕前AuthChanged狀態還沒變***
        // ***所以按下按鈕沒有反應(因為listener的callback不會執行，所以無法導向)***
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            // 導向Login Screen.
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            print(state.user.email);
            // 導向Nav Screen.
            Navigator.of(context).pushNamed(NavScreen.routeName);
          } else if (state.status == AuthStatus.unverified) {
            print(state.user.uid);
            // Navigator.of(context).pushNamed(WebviewScreen.routeName);
            // 註冊後但尚未驗證Email，導向一個頁面通知使用者去驗證Email
            Navigator.of(context).pushNamed(
              VerificationScreen.routeName,
              arguments: VerificationScreenArgs(
                // username要從firestore裡去撈
                email: state.user.email,
                // passedContext: context,
              ),
            );
          }
        },
        builder: (context, state) => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

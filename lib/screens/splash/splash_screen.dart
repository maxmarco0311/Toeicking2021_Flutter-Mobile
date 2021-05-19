import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/screens/screens.dart';
import 'package:toeicking2021/services/dynamic_links_service.dart';

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
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          // StatefulWidget在build()方法外可以取到BuildContext context(initState()除外)
          _dynamicLinkService.retrieveDynamicLink(context);
        },
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
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            // 導向Login Screen.
            // Navigator.of(context).pushNamed(LoginScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            // 導向Nav Screen.
            // Navigator.of(context).pushNamed(NavScreen.routeName);
          } else if (state.status == AuthStatus.unverified) {
            // 尚未驗證Email，導向一個頁面通知使用者去驗證Email
            Navigator.of(context).pushNamed(
              VerificationScreen.routeName,
              // username要從firestore裡去撈
              arguments: {'email': state.user.email},
            );
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

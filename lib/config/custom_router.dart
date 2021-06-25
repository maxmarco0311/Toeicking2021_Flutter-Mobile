import 'package:flutter/material.dart';
import 'package:toeicking2021/screens/screens.dart';

class CustomRouter {
  // 自訂的onGenerateRoute()函式，當MaterialApp()中onGenerateRoute屬性的callback函式
  // 傳入參數settings為建立頁面(route)所需的資料，有name和arguments兩個屬性
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    // routeName字串在settings.name裡，此函式被呼叫時(任何pushNamed()時)會傳進來
    switch (settings.name) {
      // 要定義一個根頁面
      case '/':
        return MaterialPageRoute(
          // 根頁面的routeName字串要寫死'/'
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        // route()回傳的是Route物件，其實就是一個頁面，MaterialPageRoute()就是其中一種
        return SplashScreen.route();
      case VerificationScreen.routeName:
        // 有路由參數
        return VerificationScreen.route(args: settings.arguments);
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case WebviewScreen.routeName:
        return WebviewScreen.route();
      case DetailScreen.routeName:
        return DetailScreen.route(args: settings.arguments);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}

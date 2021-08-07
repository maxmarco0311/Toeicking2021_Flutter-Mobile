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
        return WebviewScreen.route(args: settings.arguments);
      case ForgotPasswordScreen.routeName:
        return ForgotPasswordScreen.route();
      default:
        return _errorRoute();
    }
  }

  // 在TabNavigator()內運作的路由：
  // 進入bottom_nav的任何一頁"後"再導向到的頁面(ProfileScreen, EditProfileScreen, CommentsScreen)
  // 這些頁面都需要在這裡定義路由，因為進入nav_item頁面後，路由就是onGenerateNestedRoute控制
  // 因此這些頁面本身要設route()回傳Route物件，也就是MaterialPageRoute()來生畫面
  // route()可利用settings.arguments傳參數
  // 因為已經有一個更上層的路由onGenerateRoute，所以此路由稱為onGenerateNestedRoute
  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
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
          title: const Text('錯誤'),
        ),
        body: const Center(
          child: Text('出現無法預期的錯誤！'),
        ),
      ),
    );
  }
}

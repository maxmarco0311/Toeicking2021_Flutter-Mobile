import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/config/custom_router.dart';
import 'package:toeicking2021/enums/bottom_nav_item.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/screens/screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  // 從Offstage()傳過來所選中的nav_item的key
  final GlobalKey<NavigatorState> navigatorKey;
  // 從Offstage()傳過來所選中的nav_item
  final BottomNavItem item;
  // 建構式
  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 執行_routeBuilders()，將自訂的Route(或Screen)賦值(型別為Map<String, WidgetBuilder>)給變數
    final routeBuilders = _routeBuilders();
    return Navigator(
      // 就是利用這個key維持狀態
      key: navigatorKey,
      // 將初始頁面路徑字串tabNavigatorRoot賦值給initialRoute屬性
      initialRoute: tabNavigatorRoot,
      // 建立初始頁面所呼叫的callback函式，會自動傳入initialRoute屬性值(tabNavigatorRoot)
      // 回傳List<Route<dynamic>>
      onGenerateInitialRoutes: (_, initialRoute) {
        // 因為內建回傳型別為List<Route<dynamic>>，所以是return [...]
        return [
          // 回傳MaterialPageRoute<dynamic>
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            // initialRoute就是tabNavigatorRoot
            // 所以routeBuilders[initialRoute]取得Map的value(WidgetBuilder型別)
            // 也就是(context) => _getScreen(context, item)，所以要傳入context
            // 頁面就在這裡生成
            builder: (context) => routeBuilders[initialRoute](context),
          )
        ];
      },
      // Navigator內的onGenerateRoute
      // 只要是進入nav_item頁面內再pushNamed()就會觸發這個callback函式
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

// 自訂建立Route(或Screen)的方法
  // 原本MaterialApp裡的routes屬性值型別就是Map<String, WidgetBuilder>
  // 所以_routeBuilders()回傳Map<String, WidgetBuilder>來建立路由
  Map<String, WidgetBuilder> _routeBuilders() {
    // 只要呼叫_routeBuilders()，就會回傳這個TabNavigator()頁面所需內容
    // 但是是透過_getScreen(context, item)這個自訂方法達成
    // 重點是item參數，是TabNavigator()一被呼叫時所傳入的被選中的nav_item(類別必要屬性)，
    // 利用這個item去建立我們所要的頁面
    // _routeBuilders()會在TabNavigator()這個自訂widget被執行時執行
    // 1. 呼叫路徑為：TabNavigator()-->呼叫_routeBuilders()
    // 2. 回傳Map<String, WidgetBuilder>給變數routeBuilders
    // 3. 進入Navigator()後在MaterialPageRoute()裡透過routeBuilders[initialRoute](context)
    // 4. 在builder屬性值函式中回傳這個TabNavigator()頁面所需內容
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

// 真正實作Route(或Screen)的方法，依傳入的item回傳Screen()
  // 從nav_item導向到的頁面要在這裡定義或回傳
  Widget _getScreen(BuildContext context, BottomNavItem item) {
    print('_getScreen called: ${item.toString()}');
    switch (item) {
      case BottomNavItem.mode:
        return BlocProvider<SentenceBundleBloc>(
          create: (context) => SentenceBundleBloc(
            apiRepository: context.read<APIRepository>(),
            // 頁面建立時建立SentenceBundleBloc，SentenceBundleBloc建立時觸發SentenceBundleLoad事件
          )..add(
              SentenceBundleLoad(
                email: context.read<AuthBloc>().state.user.email,
                // 參數範例：{'FormData.Keyword': 'absolutely'}
                parameters: {},
              ),
            ),
          child: ModeScreen(),
        );
      case BottomNavItem.students:
        return StudentsScreen();
      case BottomNavItem.wordList:
        return WordListScreen();
      case BottomNavItem.others:
        return OtherScreen();
      default:
        return Scaffold();
    }
  }
}

import 'package:flutter/material.dart';

import 'package:toeicking2021/enums/bottom_nav_item.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  // 從Offstage()傳過來所選中的nav_item的key
  final GlobalKey<NavigatorState> navigatorKey;
  // 從Offstage()傳過來所選中的nav_item
  final BottomNavItem item;
  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

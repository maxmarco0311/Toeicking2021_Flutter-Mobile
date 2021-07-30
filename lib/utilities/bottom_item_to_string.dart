import 'package:toeicking2021/enums/bottom_nav_item.dart';

class BottomItemToString {
  static String enumToLabel(BottomNavItem item) {
    switch (item) {
      case BottomNavItem.mode:
        return '學習模式';
      case BottomNavItem.students:
        return '學員專區';
      case BottomNavItem.wordList:
        return '字彙列表';
      case BottomNavItem.others:
        return '其它';
      default:
        return '';
    }
  }
}

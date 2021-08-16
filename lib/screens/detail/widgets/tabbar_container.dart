import 'package:flutter/material.dart';

// TabBar
class TabBarContainer extends StatelessWidget {
  const TabBarContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // 不要太緊貼螢幕
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        // 有設BoxDecoration的話，color就要放在裡面，否則會報錯
        color: Colors.white,
        // 四角圓角
        borderRadius: BorderRadius.circular(25.0),
        // container陰影
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TabBar(
        // 外型客製化要從indicator屬性下手，屬性值為BoxDecoration()
        indicator: BoxDecoration(
          // 選中時tab背景色
          color: Theme.of(context).primaryColor,
          // 四邊圓角要與外層Container()設的一樣
          borderRadius: BorderRadius.circular(25.0),
        ),
        // 選中時下面那條線的粗細
        // indicatorWeight: 3.0,
        // 被選中的tab文字顏色
        labelColor: Colors.white,
        //沒被選中的tab文字顏色
        unselectedLabelColor: Colors.black87,
        //被選中的tab文字樣式，通常會是粗體
        labelStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        //沒被選中的tab文字樣式，通常沒有粗體
        unselectedLabelStyle: TextStyle(
          fontSize: 16.0,
          letterSpacing: 1.0,
        ),
        tabs: [
          Tab(text: "必考字彙"),
          Tab(text: "字彙詳解"),
          Tab(text: "文法剖析"),
        ],
      ),
    );
  }
}

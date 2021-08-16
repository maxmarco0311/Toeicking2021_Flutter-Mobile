import 'package:flutter/material.dart';

import 'package:toeicking2021/enums/bottom_nav_item.dart';
import 'package:toeicking2021/utilities/utilities.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;
  const BottomNavBar({
    Key key,
    @required this.items,
    @required this.selectedItem,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 內建物件，為bottomNavigationBar屬性值
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      // 下列兩個屬性為true，文字才會出現
      showSelectedLabels: true,
      showUnselectedLabels: true,
      // 選中時文字大小改為12.0，預設14.0會讓navbar看起來太大
      selectedFontSize: 12.0,
      iconSize: 20.0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      // .values可將enum轉成List<enum型別>，元素值為BottomNavItem.feed
      // 使用indexOf(集合元素)，可取得該元素的index值(int型別)
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
      // onTap屬性值函式會自動傳入所選中item的index
      onTap: onTap,
      // BottomNavigationBar的items屬性值須為BottomNavigationBarItem()
      items: items
          .map(
            (item, icon) => MapEntry(
              // 這個key實際沒用到，轉字串純粹為了配合型別
              item.toString(),
              // 內建物件，為items屬性值
              BottomNavigationBarItem(
                // item文字
                label: BottomItemToString.enumToLabel(item),
                // item圖片
                icon: Icon(
                  icon,
                  size: 30.0,
                ),
              ),
            ),
          )
          // 只需要BottomNavigationBarItem集合
          .values
          .toList(),
    );
  }
}

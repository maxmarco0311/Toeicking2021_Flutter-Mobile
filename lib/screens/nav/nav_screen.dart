import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toeicking2021/enums/bottom_nav_item.dart';
import 'package:toeicking2021/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:toeicking2021/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    // PageRouteBuilder是可以設計動畫的換頁，這裡利用transitionDuration為0
    // 讓此頁是感覺疊加在SplashScreen上出現，MaterialPageRoute頁面是由側邊滑入的
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  // NavScreen不用建構式
  NavScreen({Key key}) : super(key: key);

  // 每一個bottom item都要有一個個別的GlobalKey<NavigatorState>，才可以追蹤navigation狀態
  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.mode: GlobalKey<NavigatorState>(),
    BottomNavItem.students: GlobalKey<NavigatorState>(),
    BottomNavItem.wordList: GlobalKey<NavigatorState>(),
    BottomNavItem.others: GlobalKey<NavigatorState>(),
  };
  // map for bottom item
  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.mode: MdiIcons.home,
    BottomNavItem.students: MdiIcons.pencilCircle,
    BottomNavItem.wordList: Icons.list,
    BottomNavItem.others: Icons.settings,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: items
                  .map((item, _) => MapEntry(
                        // 雖然key不會用到，但還是要填入item變數
                        // 這樣MapEntry的型別才會符合，Offstage才會正常出現
                        // 原本填入key變數，被視為是Key型別物件，MapEntry型別不符合
                        // 所以Offstage沒有出現
                        item,
                        // 會產生5個screen在stack裡
                        // 但透過Offstage()的屬性值設定可隱藏非選中的screen
                        _buildOffstageNavigator(
                          // 目前要生的nav item
                          item,
                          // 是否為目前所選的nav item
                          item == state.selectedItem,
                        ),
                      ))
                  .values
                  .toList(),
            ),
            // 底部導航
            bottomNavigationBar: BottomNavBar(
              items: items,
              selectedItem: state.selectedItem,
              // 這裡index傳入參數是內建物件BottomNavigationBar的onTap屬性值函式中自動傳入
              // 是被選中的bottom item的index值(from 0)
              onTap: (index) {
                // 找出被選中的bottom item的enum值
                final selectedItem = BottomNavItem.values[index];
                // 按下nav_item後要做的事
                _selectBottomNavItem(
                  // 呼叫cubit實體用
                  context,
                  // 更新被選中的bottom item狀態
                  selectedItem,
                  // 判斷按的bottom item是否為目前所在的bottom item
                  selectedItem == state.selectedItem,
                );
              },
            ),
          );
        },
      ),
    );
  }

  // 按下nav_item後要做的事
  void _selectBottomNavItem(
    BuildContext context,
    BottomNavItem selectedItem,
    bool isSameItem,
  ) {
    // 如果在某一個nav item頁面中導向到其它頁後(不是透過按其它bottom item)
    // 又再按了一次目前所在的nav item
    if (isSameItem) {
      // 就要回到這個nav item最初會顯示的頁面
      navigatorKeys[selectedItem]
          // 類似Navigator.of<context>，但有global key的狀態，也就是有screen stack history
          .currentState
          // 所以才可以呼叫popUntil()
          // popUntil()表一直pop screen stack中的最上層screen
          // 直到lambda predicate(route.isFirst)回傳true為止
          // isFirst指的是這個screen stack中最底層的screen
          // 所以(route) => route.isFirst表會導回到screen stack中最底層的screen
          // 就是這個bottom item最初會顯示的畫面
          .popUntil((route) => route.isFirst);
    }
    // 如果按的是不同的bottom item
    // 就只有改變selectedItem的狀態(cubit)
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  // 生出每個nav item頁面的方法(回傳值為Widget)
  Widget _buildOffstageNavigator(
    BottomNavItem currentItem,
    bool isSelected,
  ) {
    // Offstage()是一種可讓child widget不顯示的widget
    return Offstage(
      // 由offstage的布林屬性值決定是否讓child widget顯示
      // ***true(預設)-->child widget"不"顯示***
      // ***false-->child widget"會"顯示***
      // offstage屬性值設成!isSelected的原因：
      // 1. 目的是要所選到nav_item(screen)才顯示，其他非所選的不顯示
      // 2. selectedItem == state.selectedItem是true代表stack children的迴圈中生到nav選中的nav_item
      // 3. 但offstage屬性值要false才會顯示，所以必須要設成!isSelected
      // 4. 所以當stack children的迴圈中生到"非"nav選中的nav_item時
      // 5. selectedItem == state.selectedItem就會變成false，但因為不要顯示這些screen
      // 6. 要將offstage屬性值變成true，所以要設成!isSelected
      offstage: !isSelected,
      // TabNavigator為自訂widget，回傳Navigator()
      // 為一個可保持child widgets導向狀態(stack history)的widget
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        // 傳入被選中的item
        item: currentItem,
      ),
    );
  }
}

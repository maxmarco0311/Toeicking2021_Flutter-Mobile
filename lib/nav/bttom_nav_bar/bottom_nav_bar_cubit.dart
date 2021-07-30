import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/enums/bottom_nav_item.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      :
        // 初始狀態為BottomNavBarState(selectedItem: BottomNavItem.mode)
        // 第一個顯示的頁面為ModeScreen()
        super(BottomNavBarState(selectedItem: BottomNavItem.mode));

  // 更新選中的nav_item
  void updateSelectedItem(BottomNavItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}

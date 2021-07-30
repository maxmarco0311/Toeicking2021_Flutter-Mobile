part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  // 唯一需要的資料是選中的nav_item(BottomNavItem的列舉值)
  final BottomNavItem selectedItem;
  const BottomNavBarState({
    @required this.selectedItem,
  });

  @override
  List<Object> get props => [];
}

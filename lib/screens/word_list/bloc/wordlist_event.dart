part of 'wordlist_bloc.dart';

abstract class WordlistEvent extends Equatable {
  const WordlistEvent();

  @override
  List<Object> get props => [];
}

// 剛進入該頁，撈第一頁(頁面建立時就要觸發的)
class WordlistLoad extends WordlistEvent {
  // 晚一點再測試篩選條件
  // final String condition;
  final String pageSize;
  final String currentPage;
  final String email;
  WordlistLoad({
    // @required this.condition,
    @required this.pageSize,
    @required this.currentPage,
    @required this.email,
  });
  @override
  List<Object> get props => [pageSize, currentPage];
}

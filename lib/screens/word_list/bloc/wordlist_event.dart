part of 'wordlist_bloc.dart';

abstract class WordlistEvent extends Equatable {
  const WordlistEvent();

  @override
  List<Object> get props => [];
}

// 剛進入該頁，撈第一頁(頁面建立時就要觸發的)
class WordlistInitLoad extends WordlistEvent {
  final String condition;
  final int pageSize;
  final int currentPage;
  WordlistInitLoad({
    @required this.condition,
    @required this.pageSize,
    @required this.currentPage,
  });
  @override
  List<Object> get props => [condition, pageSize, currentPage];
}

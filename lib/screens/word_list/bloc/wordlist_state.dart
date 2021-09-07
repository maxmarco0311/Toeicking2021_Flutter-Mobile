part of 'wordlist_bloc.dart';

enum WordlistStateStatus { initial, loading, loaded, error }

class WordlistState extends Equatable {
  // 進入這頁的初始搜尋條件
  final String initSearchCondition;
  // 目前的字彙集合(要顯示的List)
  final List<Vocabulary> currentList;
  // 目前頁數
  final int currentPage;
  // 下一頁的字彙集合，要加進currentList
  final List<Vocabulary> paginatedList;
  // 搜尋文字框內輸入要搜尋的字串
  final String currentSearchCondition;
  // 顯示符合文字框搜尋條件的字彙集合，如果有，會取代currentList
  final List<Vocabulary> searchedList;
  // 最近文字框內搜尋條件(字串)集合
  final List<String> recentSearchedStringList;
  // 狀態
  final WordlistStateStatus status;

  const WordlistState(
      {@required this.initSearchCondition,
      @required this.currentList,
      @required this.currentPage,
      @required this.paginatedList,
      @required this.currentSearchCondition,
      @required this.searchedList,
      @required this.recentSearchedStringList,
      @required this.status});

  @override
  List<Object> get props {
    return [
      initSearchCondition,
      currentList,
      currentPage,
      paginatedList,
      currentSearchCondition,
      searchedList,
      recentSearchedStringList,
    ];
  }

  factory WordlistState.initial() {
    return const WordlistState(
      initSearchCondition: '',
      currentList: [],
      currentPage: 1,
      paginatedList: [],
      currentSearchCondition: '',
      searchedList: [],
      recentSearchedStringList: [],
      status: WordlistStateStatus.initial,
    );
  }

  WordlistState copyWith({
    String initSearchCondition,
    List<Vocabulary> currentList,
    int currentPage,
    List<Vocabulary> paginatedList,
    String currentSearchCondition,
    List<Vocabulary> searchedList,
    List<String> recentSearchedStringList,
    WordlistStateStatus status,
  }) {
    return WordlistState(
      initSearchCondition: initSearchCondition ?? this.initSearchCondition,
      currentList: currentList ?? this.currentList,
      currentPage: currentPage ?? this.currentPage,
      paginatedList: paginatedList ?? this.paginatedList,
      currentSearchCondition:
          currentSearchCondition ?? this.currentSearchCondition,
      searchedList: searchedList ?? this.searchedList,
      recentSearchedStringList:
          recentSearchedStringList ?? this.recentSearchedStringList,
      status: status ?? this.status,
    );
  }
}

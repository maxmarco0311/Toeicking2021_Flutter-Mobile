import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/models/first_page_vocabulary.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/repositories.dart';

part 'wordlist_event.dart';
part 'wordlist_state.dart';

class WordlistBloc extends Bloc<WordlistEvent, WordlistState> {
  APIRepository _apiRepository;

  WordlistBloc({
    @required APIRepository apiRepository,
  })  : _apiRepository = apiRepository ?? APIRepository.instance,
        super(
          WordlistState.initial(),
        );

  @override
  Stream<WordlistState> mapEventToState(
    WordlistEvent event,
  ) async* {
    if (event is WordlistLoad) {
      yield* _mapWordlistLoadToState(event);
    }
  }

  // 載入每頁字彙列表(含第一頁及第二頁以上)
  // ***要處理初次登入的user情境：設條件先不要撈wordLsit***
  Stream<WordlistState> _mapWordlistLoadToState(
    WordlistLoad event,
  ) async* {
    // 查第二頁以上-->要合併原有的字彙與新查到的字彙
    if (int.parse(event.currentPage) > 1 &&
        // 附加條件: 查完最後一頁後，只能再最後一次進來此方法-->所以要小於等於總頁數+1
        int.parse(event.currentPage) <= state.totalPages + 1) {
      // 巢狀條件1：查第二頁到最後一頁
      if (int.parse(event.currentPage) <= state.totalPages) {
        // 先更新狀態再開始查
        yield state.copyWith(status: WordlistStateStatus.paginating);
        List<Vocabulary> vocabularies = await _apiRepository.getWordList(
          pageToLoad: event.currentPage,
          pageSize: event.pageSize,
          email: event.email,
        );
        // 兩個集合合併只要用加號即可
        List<Vocabulary> accumulatedVocabularies =
            state.currentList + vocabularies;
        // 更新狀態
        yield state.copyWith(
          currentList: accumulatedVocabularies,
          // 要更新目前頁數
          currentPage: int.tryParse(event.currentPage),
          // 查完還要再更新狀態
          status: WordlistStateStatus.loaded,
        );
      }
      // 巢狀條件2：查完最後一頁後下一次進來
      else if (int.parse(event.currentPage) == state.totalPages + 1) {
        yield state.copyWith(
          // 將狀態改為loadedOut，顯示字彙已載入完成
          status: WordlistStateStatus.loadedOut,
          // 要把state的currentPage存為totalPages+1，所以之後都不能再進入這個方法(因為event的currentPage會是state的currentPage+2)
          // 因為有設條件：context.read<WordlistBloc>().state.currentPage <= (context.read<WordlistBloc>().state.totalPages) + 1
          // 也因此字彙已載入完成只會顯示一次，若要每次都顯示，就不要存入這個狀態即可
          // currentPage就會一直等於totalPages
          currentPage: int.tryParse(event.currentPage),
        );
      }
    }
    // 查第一頁
    else if (int.parse(event.currentPage) == 1) {
      yield state.copyWith(status: WordlistStateStatus.loading);
      // 呼叫專屬查第一頁的api(因為要順便查總頁數)
      FirstPageVocabulary firstPageVocabulary =
          await _apiRepository.getFirstPageWordList(
        pageToLoad: event.currentPage,
        pageSize: event.pageSize,
        email: event.email,
      );
      yield state.copyWith(
        currentList: firstPageVocabulary.vocabularies,
        currentPage: int.tryParse(event.currentPage),
        // 將總頁數存入狀態中
        totalPages: firstPageVocabulary.totalPages,
        status: WordlistStateStatus.loaded,
      );
    }
  }
}

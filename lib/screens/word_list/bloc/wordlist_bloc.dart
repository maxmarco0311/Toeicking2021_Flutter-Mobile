import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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

  // 載入第一頁
  Stream<WordlistState> _mapWordlistLoadToState(
    WordlistLoad event,
  ) async* {
    List<Vocabulary> vocabularies = await _apiRepository.getWordList(
      pageToLoad: event.currentPage,
      pageSize: event.pageSize,
      email: event.email,
    );
    // 查第二頁以上要合併原有的字彙與新查到的字彙
    if (int.parse(event.currentPage) > 1) {
      // 兩個集合合併只要用加號即可
      List<Vocabulary> accumulatedVocabularies =
          state.currentList + vocabularies;
      state.copyWith(currentList: accumulatedVocabularies);
    }
    // 查第一頁
    else if (int.parse(event.currentPage) == 1) {
      yield state.copyWith(currentList: vocabularies);
    }
  }
}

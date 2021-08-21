import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/api/api_repository.dart';

part 'sentencebundle_event.dart';
part 'sentencebundle_state.dart';

class SentenceBundleBloc
    extends Bloc<SentenceBundleEvent, SentenceBundleState> {
  final APIRepository _apiRepository;

  SentenceBundleBloc({@required APIRepository apiRepository})
      : _apiRepository = apiRepository ?? APIRepository.instance,
        super(SentenceBundleState.initial());

  @override
  Stream<SentenceBundleState> mapEventToState(
    SentenceBundleEvent event,
  ) async* {
    if (event is SentenceBundleLoad) {
      yield* _mapSentenceBundleLoadToState(event);
    }
  }

  // 載入符合條件的句子
  Stream<SentenceBundleState> _mapSentenceBundleLoadToState(
    SentenceBundleLoad event,
  ) async* {
    yield state.copyWith(status: SentenceBundleStateStatus.loading);
    // 撈符合條件的sentenceBundles
    List<SentenceBundle> sentenceBundles =
        await _apiRepository.getSentenceBundles(
      email: event.email,
      parameters: event.parameters,
    );
    yield state.copyWith(
      sentenceBundles: sentenceBundles,
      // user: user,
      status: SentenceBundleStateStatus.loaded,
    );
  }
}

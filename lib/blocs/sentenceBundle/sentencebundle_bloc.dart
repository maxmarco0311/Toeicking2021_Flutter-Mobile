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
    } else if (event is SentenceBundleLoadBySentenceId) {
      yield* _mapSentenceBundleLoadBySentenceIdToState(event);
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

  // 依句子編號查出sentenceBundle
  Stream<SentenceBundleState> _mapSentenceBundleLoadBySentenceIdToState(
    SentenceBundleLoadBySentenceId event,
  ) async* {
    yield state.copyWith(status: SentenceBundleStateStatus.loading);
    // 依編號查出sentenceBundle
    SentenceBundle sentenceBundle =
        await _apiRepository.getSentenceBundleBySentenceId(
      email: event.email,
      sentenceId: event.sentenceId.toString(),
    );
    yield state.copyWith(
      sentenceBundle: sentenceBundle,
      // user: user,
      status: SentenceBundleStateStatus.loaded,
    );
  }
}

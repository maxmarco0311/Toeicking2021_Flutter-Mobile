import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toeicking2021/repositories/api/api_repository.dart';
import 'package:toeicking2021/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  APIRepository _apiRepository;

  UserBloc({
    @required APIRepository apiRepository,
  })  : _apiRepository = apiRepository ?? APIRepository.instance,
        super(
          UserState.initial(),
        );

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserFetch) {
      yield* _mapUserFetchToState(event);
    } else if (event is AddWordList) {
      yield* _mapAddWordListToState(event);
    }
  }

  Stream<UserState> _mapUserFetchToState(UserFetch event) async* {
    UserState user = await _apiRepository.getUser(email: event.email);
    print('getUser called!');
    yield state.copyWith(
      email: user.email,
      valid: user.valid,
      rating: user.rating,
      wordList: user.wordList,
    );
  }

  // 加入wordList
  Stream<UserState> _mapAddWordListToState(AddWordList event) async* {
    UserState user = await _apiRepository.addWordList(
        email: event.email, vocabularyId: event.vocabularyId.toString());
    yield state.copyWith(
      wordList: user.wordList,
    );
  }
}

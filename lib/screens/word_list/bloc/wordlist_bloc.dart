import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/models/models.dart';

part 'wordlist_event.dart';
part 'wordlist_state.dart';

class WordlistBloc extends Bloc<WordlistEvent, WordlistState> {
  WordlistBloc() : super(WordlistState.inital());

  @override
  Stream<WordlistState> mapEventToState(
    WordlistEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

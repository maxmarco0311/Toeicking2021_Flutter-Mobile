import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/repositories/repositories.dart';

part 'audiosetting_event.dart';
part 'audiosetting_state.dart';

class AudioSettingBloc extends Bloc<AudioSettingEvent, AudioSettingState> {
  final LocalDataRepository _localDataRepository;
  AudioSettingBloc({
    @required LocalDataRepository localDataRepository,
  })  : _localDataRepository =
            localDataRepository ?? LocalDataRepository.instance,
        super(
          AudioSettingState.initial(),
        );

  @override
  Stream<AudioSettingState> mapEventToState(
    AudioSettingEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

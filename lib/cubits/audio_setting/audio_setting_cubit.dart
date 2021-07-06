import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'audio_setting_state.dart';

class AudioSettingCubit extends Cubit<AudioSettingState> {
  AudioSettingCubit()
      : super(
          AudioSettingState.initial(),
        );

  void updateAccent({
    @required String accent,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) {
    statusStreamController.sink.add(status);
    emit(
      state.copyWith(
        accent: accent,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
  }

  void updateGender({
    @required String gender,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) {
    statusStreamController.sink.add(status);
    emit(
      state.copyWith(
        gender: gender,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
  }

  void updateRate({
    @required String rate,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) {
    statusStreamController.sink.add(status);
    emit(
      state.copyWith(
        rate: rate,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
  }

  void updateRepeatedTimes({
    @required int repeatedTimes,
    @required Status status,
    @required StreamController<Status> statusStreamController,
  }) {
    statusStreamController.sink.add(status);
    // 一更新重複撥放次數，已播放次數就要歸零
    emit(
      state.copyWith(
        repeatedTimes: repeatedTimes,
        status: status,
        statusStreamController: statusStreamController,
      ),
    );
  }
}

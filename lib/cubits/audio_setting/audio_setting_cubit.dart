import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'audio_setting_state.dart';

class AudioSettingCubit extends Cubit<AudioSettingState> {
  AudioSettingCubit()
      : super(
          AudioSettingState.initial(),
        );

  void updateAccent({@required String accent}) {
    emit(
      state.copyWith(accent: accent),
    );
  }

  void updateGender({@required String gender}) {
    emit(
      state.copyWith(gender: gender),
    );
  }

  void updateRate({@required String rate}) {
    emit(
      state.copyWith(rate: rate),
    );
  }

  void updateRepeatedTimes({@required int repeatedTimes}) {
    emit(
      state.copyWith(repeatedTimes: repeatedTimes),
    );
  }
}

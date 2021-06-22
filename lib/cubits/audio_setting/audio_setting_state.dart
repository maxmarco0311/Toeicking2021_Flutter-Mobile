part of 'audio_setting_cubit.dart';

class AudioSettingState extends Equatable {
  final String accent;
  final String gender;
  final String rate;
  final int repeatedTimes;

  const AudioSettingState({
    @required this.accent,
    @required this.gender,
    @required this.rate,
    @required this.repeatedTimes,
  });

  factory AudioSettingState.initial() {
    return AudioSettingState(
      accent: 'US',
      gender: 'M',
      rate: '1.0',
      repeatedTimes: 0,
    );
  }

  @override
  List<Object> get props => [accent, gender, rate, repeatedTimes];

  AudioSettingState copyWith({
    String accent,
    String gender,
    String rate,
    int repeatedTimes,
  }) {
    return AudioSettingState(
      accent: accent ?? this.accent,
      gender: gender ?? this.gender,
      rate: rate ?? this.rate,
      repeatedTimes: repeatedTimes ?? this.repeatedTimes,
    );
  }
}

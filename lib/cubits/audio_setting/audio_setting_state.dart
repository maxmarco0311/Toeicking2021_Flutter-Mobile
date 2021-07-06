part of 'audio_setting_cubit.dart';

enum Status {
  initial,
  accentUpdate,
  genderUpdate,
  rateUpdate,
  repeatedTimesUpdate,
  failure,
}

class AudioSettingState extends Equatable {
  final String accent;
  final String gender;
  final String rate;
  final int repeatedTimes;
  final Status status;
  final StreamController<Status> statusStreamController;
  
  const AudioSettingState({
    @required this.accent,
    @required this.gender,
    @required this.rate,
    @required this.repeatedTimes,
    @required this.status,
    @required this.statusStreamController,
  });

  factory AudioSettingState.initial() {
    return AudioSettingState(
      accent: 'US',
      gender: 'M',
      rate: '1.0',
      repeatedTimes: 0,
      status: Status.initial,
      statusStreamController: StreamController<Status>(),
    );
  }

  @override
  List<Object> get props => [
        accent,
        gender,
        rate,
        repeatedTimes,
        status,
        statusStreamController,
      ];

  AudioSettingState copyWith({
    String accent,
    String gender,
    String rate,
    int repeatedTimes,
    Status status,
    StreamController<Status> statusStreamController,
    StreamController<String> updateTimesStreamController,
  }) {
    return AudioSettingState(
      accent: accent ?? this.accent,
      gender: gender ?? this.gender,
      rate: rate ?? this.rate,
      repeatedTimes: repeatedTimes ?? this.repeatedTimes,
      status: status,
      statusStreamController:
          statusStreamController ?? this.statusStreamController,
    );
  }
}

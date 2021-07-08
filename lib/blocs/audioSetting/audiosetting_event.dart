part of 'audiosetting_bloc.dart';

abstract class AudioSettingEvent extends Equatable {
  const AudioSettingEvent();

  @override
  List<Object> get props => [];
}

class AudioSettingGetLocalStorageData extends AudioSettingEvent {
  const AudioSettingGetLocalStorageData();
  @override
  List<Object> get props => [];
}

class AudioSettingUpdateAccent extends AudioSettingEvent {
  final String accent;
  final Status status;
  final StreamController<Status> statusStreamController;

  const AudioSettingUpdateAccent({
    @required this.accent,
    @required this.status,
    @required this.statusStreamController,
  });
  @override
  List<Object> get props => [accent, status, statusStreamController];
}

class AudioSettingUpdateGender extends AudioSettingEvent {
  final String gender;
  final Status status;
  final StreamController<Status> statusStreamController;

  const AudioSettingUpdateGender({
    @required this.gender,
    @required this.status,
    @required this.statusStreamController,
  });
  @override
  List<Object> get props => [gender, status, statusStreamController];
}

class AudioSettingUpdateRate extends AudioSettingEvent {
  final String rate;
  final Status status;
  final StreamController<Status> statusStreamController;

  const AudioSettingUpdateRate({
    @required this.rate,
    @required this.status,
    @required this.statusStreamController,
  });
  @override
  List<Object> get props => [rate, status, statusStreamController];
}

class AudioSettingUpdateRepeatedTimes extends AudioSettingEvent {
  final int repeatedTimes;
  final Status status;
  final StreamController<Status> statusStreamController;

  const AudioSettingUpdateRepeatedTimes({
    @required this.repeatedTimes,
    @required this.status,
    @required this.statusStreamController,
  });
  @override
  List<Object> get props => [repeatedTimes, status, statusStreamController];
}

part of 'audiosetting_bloc.dart';

enum Status {
  initial,
  initStateLoading,
  initStateLoaded,
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
  // 有了StreamController<T>物件，就可以做兩件事：
  // 1. 呼叫.sink.add(T型別值)傳資料進入stream，並觸發stream
  // 2. 呼叫.stream.listen((T型別參數){})，監聽取得這個stream觸發時所傳入的資料，並做相應處理
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
  List<Object> get props {
    return [
      accent,
      gender,
      rate,
      repeatedTimes,
      status,
      statusStreamController,
    ];
  }

  AudioSettingState copyWith({
    String accent,
    String gender,
    String rate,
    int repeatedTimes,
    Status status,
    StreamController<Status> statusStreamController,
  }) {
    return AudioSettingState(
      accent: accent ?? this.accent,
      gender: gender ?? this.gender,
      rate: rate ?? this.rate,
      repeatedTimes: repeatedTimes ?? this.repeatedTimes,
      status: status ?? this.status,
      statusStreamController:
          statusStreamController ?? this.statusStreamController,
    );
  }
}

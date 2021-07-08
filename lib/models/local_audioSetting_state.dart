import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LocalAudioSettingState extends Equatable {
  final int id;
  final String accent;
  final String gender;
  final String rate;
  final int repeatedTimes;

  LocalAudioSettingState({
    @required this.id,
    @required this.accent,
    @required this.gender,
    @required this.rate,
    @required this.repeatedTimes,
  });
  @override
  List<Object> get props {
    return [
      id,
      accent,
      gender,
      rate,
      repeatedTimes,
    ];
  }

  LocalAudioSettingState copyWith({
    int id,
    String accent,
    String gender,
    String rate,
    int repeatedTimes,
  }) {
    return LocalAudioSettingState(
      id: id ?? this.id,
      accent: accent ?? this.accent,
      gender: gender ?? this.gender,
      rate: rate ?? this.rate,
      repeatedTimes: repeatedTimes ?? this.repeatedTimes,
    );
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    // 初次新增，會沒有id，所以要檢查
    if (id != null) {
      map['id'] = id;
    }
    map['accent'] = accent;
    map['gender'] = gender;
    map['rate'] = rate;
    map['repeatedTimes'] = repeatedTimes;
    return map;
  }

  factory LocalAudioSettingState.fromMap(Map<String, dynamic> map) {
    return LocalAudioSettingState(
      id: map['id'],
      accent: map['accent'],
      gender: map['gender'],
      rate: map['rate'],
      repeatedTimes: map['repeatedTimes'],
    );
  }
}

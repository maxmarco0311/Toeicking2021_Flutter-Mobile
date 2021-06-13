import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Sentence extends Equatable {
  final int sentenceId;
  final String sen;
  final String chinesese;

  const Sentence(
      {@required this.sentenceId,
      @required this.sen,
      @required this.chinesese});

  @override
  List<Object> get props => [sentenceId, sen, chinesese];

  Sentence copyWith({
    int sentenceId,
    String sen,
    String chinesese,
  }) {
    return Sentence(
      sentenceId: sentenceId ?? this.sentenceId,
      sen: sen ?? this.sen,
      chinesese: chinesese ?? this.chinesese,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SentenceId': sentenceId,
      'Sen': sen,
      'Chinesese': chinesese,
    };
  }

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      sentenceId: map['sentenceId'],
      sen: map['sen'],
      chinesese: map['chinesese'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Sentence.fromJson(String source) =>
      Sentence.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

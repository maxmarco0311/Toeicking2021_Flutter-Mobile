import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Vocabulary extends Equatable {
  final int sentenceId;
  final int vocabularyId;
  final String voc;
  final String category;
  final String chinese;

  const Vocabulary(
      {@required this.sentenceId,
      @required this.vocabularyId,
      @required this.voc,
      @required this.category,
      @required this.chinese});

  @override
  List<Object> get props => [sentenceId, vocabularyId, voc, category, chinese];

  Map<String, dynamic> toMap() {
    return {
      'sentenceId': sentenceId,
      'vocabularyId': vocabularyId,
      'voc': voc,
      'category': category,
      'chinese': chinese,
    };
  }

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      sentenceId: map['sentenceId'],
      vocabularyId: map['vocabularyId'],
      voc: map['voc'],
      category: map['category'],
      chinese: map['chinese'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Vocabulary.fromJson(String source) =>
      Vocabulary.fromMap(json.decode(source));

  Vocabulary copyWith({
    int sentenceId,
    int vocabularyId,
    String voc,
    String category,
    String chinese,
  }) {
    return Vocabulary(
      sentenceId: sentenceId ?? this.sentenceId,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      voc: voc ?? this.voc,
      category: category ?? this.category,
      chinese: chinese ?? this.chinese,
    );
  }

  @override
  bool get stringify => true;
}

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toeicking2021/models/models.dart';

class FirstPageVocabulary extends Equatable {
  final List<Vocabulary> vocabularies;
  final int totalPages;
  const FirstPageVocabulary({
    @required this.vocabularies,
    @required this.totalPages,
  });

  @override
  List<Object> get props => [vocabularies, totalPages];

  FirstPageVocabulary copyWith({
    List<Vocabulary> vocabularies,
    int totalPages,
  }) {
    return FirstPageVocabulary(
      vocabularies: vocabularies ?? this.vocabularies,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vocabularies': vocabularies?.map((x) => x.toMap())?.toList(),
      'totalPages': totalPages,
    };
  }

  factory FirstPageVocabulary.fromMap(Map<String, dynamic> map) {
    return FirstPageVocabulary(
      vocabularies: List<Vocabulary>.from(
          map['vocabularies']?.map((x) => Vocabulary.fromMap(x))),
      totalPages: map['totalPages'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FirstPageVocabulary.fromJson(String source) =>
      FirstPageVocabulary.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

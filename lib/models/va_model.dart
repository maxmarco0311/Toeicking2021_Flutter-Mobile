import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class VA extends Equatable {
  final int analysisId;
  final String analysis;

  const VA({
    @required this.analysisId,
    @required this.analysis,
  });

  VA copyWith({
    int analysisId,
    String analysis,
  }) {
    return VA(
      analysisId: analysisId ?? this.analysisId,
      analysis: analysis ?? this.analysis,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'AnalysisId': analysisId,
      'Analysis': analysis,
    };
  }

  factory VA.fromMap(Map<String, dynamic> map) {
    return VA(
      analysisId: map['analysisId'],
      analysis: map['analysis'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VA.fromJson(String source) => VA.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [analysisId, analysis];
}

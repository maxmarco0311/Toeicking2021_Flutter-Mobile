import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GA extends Equatable {
  final int analysisId;
  final String analysis;

  const GA({
    @required this.analysisId,
    @required this.analysis,
  });
  @override
  List<Object> get props => [analysisId, analysis];

  GA copyWith({
    int analysisId,
    String analysis,
  }) {
    return GA(
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

  factory GA.fromMap(Map<String, dynamic> map) {
    return GA(
      analysisId: map['analysisId'],
      analysis: map['analysis'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GA.fromJson(String source) => GA.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

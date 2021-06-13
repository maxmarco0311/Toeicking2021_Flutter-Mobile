import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:toeicking2021/models/models.dart';

class SentenceBundle extends Equatable {
  final Sentence sentence;
  final List<Vocabulary> vocabularies;
  final List<GA> gas;
  final List<VA> vas;
  final Map<String, String> normalAudioUrls;
  final Map<String, String> fastAudioUrls;
  final Map<String, String> slowAudioUrls;

  SentenceBundle(
      {@required this.sentence,
      @required this.vocabularies,
      @required this.gas,
      @required this.vas,
      @required this.normalAudioUrls,
      @required this.fastAudioUrls,
      @required this.slowAudioUrls});

  SentenceBundle copyWith({
    Sentence sentence,
    List<Vocabulary> vocabularies,
    List<GA> gas,
    List<VA> vas,
    Map<String, String> normalAudioUrls,
    Map<String, String> fastAudioUrls,
    Map<String, String> slowAudioUrls,
  }) {
    return SentenceBundle(
      sentence: sentence ?? this.sentence,
      vocabularies: vocabularies ?? this.vocabularies,
      gas: gas ?? this.gas,
      vas: vas ?? this.vas,
      normalAudioUrls: normalAudioUrls ?? this.normalAudioUrls,
      fastAudioUrls: fastAudioUrls ?? this.fastAudioUrls,
      slowAudioUrls: slowAudioUrls ?? this.slowAudioUrls,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Sentence': sentence.toMap(),
      'Vocabularies': vocabularies?.map((x) => x.toMap())?.toList(),
      'Gas': gas?.map((x) => x.toMap())?.toList(),
      'Vas': vas?.map((x) => x.toMap())?.toList(),
      'NormalAudioUrls': normalAudioUrls,
      'FastAudioUrls': fastAudioUrls,
      'SlowAudioUrls': slowAudioUrls,
    };
  }

  // 參數map實質上為sourceMap[data][index]：
  // Map<String, dynamic> sourceMap = json.decode(response.body);
  // 1. response.body轉成Map後，資料都放在data屬性裡，所以要用sourceMap[data]
  // 2. data屬性裡的資料為List<Map<String, dynamic>>
  // 3. 因為是集合，所以每一筆SentenceBundle的Map要用[index]取得

  // 要一次取得List<SentenceBundle>可用下列方式：
  // 寫法1:
  // Map<String, dynamic> sourceMap = json.decode(response.body);
  // List<SentenceBundle> sentences = List<SentenceBundle>.from(
  //   sourceMap[data]?.map(
  //     (SentenceBundleMap) => SentenceBundle.fromMap(SentenceBundleMap),
  //   ),
  // );
  // 寫法2:
  // Map<String, dynamic> sourceMap = json.decode(response.body);
  // List<SentenceBundle> sentences = [];
  // sourceMap[data].forEach((SentenceBundleMap)=> sentences.Add(SentenceBundle.fromMap(SentenceBundleMap)));
  factory SentenceBundle.fromMap(Map<String, dynamic> map) {
    return SentenceBundle(
      sentence: Sentence.fromMap(map['sentence']),
      vocabularies: List<Vocabulary>.from(
          map['vocabularies']?.map((x) => Vocabulary.fromMap(x))),
      gas: List<GA>.from(map['gas']?.map((x) => GA.fromMap(x))),
      vas: List<VA>.from(map['vas']?.map((x) => VA.fromMap(x))),
      normalAudioUrls: Map<String, String>.from(map['normalAudioUrls']),
      fastAudioUrls: Map<String, String>.from(map['fastAudioUrls']),
      slowAudioUrls: Map<String, String>.from(map['slowAudioUrls']),
    );
  }

  String toJson() => json.encode(toMap());

  // source為每筆SentenceBundle的Map的原始字串
  // 所以這個建構式不會用到，因為我的情境response.body要先json.decode()才有辦法取得每筆SentenceBundle的Map
  factory SentenceBundle.fromJson(String source) =>
      SentenceBundle.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      sentence,
      vocabularies,
      gas,
      vas,
      normalAudioUrls,
      fastAudioUrls,
      slowAudioUrls,
    ];
  }
}

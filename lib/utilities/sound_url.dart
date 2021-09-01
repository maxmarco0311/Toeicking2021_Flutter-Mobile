import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/models/models.dart';

class SoundUrl {
  static String getUrlBySetting(
    AudioSettingState audioState,
    SentenceBundleState sentenceBundleState,
    bool fromWordList,
    SentenceBundle sentenceBundle,
  ) {
    String urlDicKey = audioState.accent + audioState.gender;
    String url = '';
    switch (audioState.rate) {
      case '0.75':
        url = fromWordList
            ? sentenceBundleState.sentenceBundle.slowAudioUrls[urlDicKey]
            : sentenceBundle.slowAudioUrls[urlDicKey];
        break;
      case '1.0':
        url = fromWordList
            ? sentenceBundleState.sentenceBundle.normalAudioUrls[urlDicKey]
            : sentenceBundle.normalAudioUrls[urlDicKey];
        break;
      case '1.25':
        url = fromWordList
            ? sentenceBundleState.sentenceBundle.fastAudioUrls[urlDicKey]
            : sentenceBundle.fastAudioUrls[urlDicKey];
        break;
      default:
        url = '';
    }
    return url;
  }
}

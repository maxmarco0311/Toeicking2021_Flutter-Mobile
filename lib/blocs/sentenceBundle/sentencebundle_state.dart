part of 'sentencebundle_bloc.dart';

enum SentenceBundleStateStatus { initial, loading, loaded, error }

class SentenceBundleState extends Equatable {
  final List<SentenceBundle> sentenceBundles;
  final SentenceBundleStateStatus status;
  final SentenceBundle sentenceBundle;

  const SentenceBundleState({
    @required this.sentenceBundles,
    @required this.status,
    @required this.sentenceBundle,
  });

  factory SentenceBundleState.initial() {
    return const SentenceBundleState(
      sentenceBundles: [],
      sentenceBundle: SentenceBundle(
        sentence: Sentence(sentenceId: 0, sen: '', chinesese: ''),
        vocabularies: [],
        gas: [],
        vas: [],
        normalAudioUrls: {},
        fastAudioUrls: {},
        slowAudioUrls: {},
      ),
      status: SentenceBundleStateStatus.initial,
    );
  }

  @override
  List<Object> get props => [sentenceBundles, status];

  SentenceBundleState copyWith(
      {List<SentenceBundle> sentenceBundles,
      SentenceBundleStateStatus status,
      SentenceBundle sentenceBundle}) {
    return SentenceBundleState(
      sentenceBundles: sentenceBundles ?? this.sentenceBundles,
      sentenceBundle: sentenceBundle ?? this.sentenceBundle,
      status: status ?? this.status,
    );
  }
}

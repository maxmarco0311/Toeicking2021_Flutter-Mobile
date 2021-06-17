part of 'sentencebundle_bloc.dart';

enum SentenceBundleStateStatus { initial, loading, loaded, error }

class SentenceBundleState extends Equatable {
  final List<SentenceBundle> sentenceBundles;
  final SentenceBundleStateStatus status;

  const SentenceBundleState({
    @required this.sentenceBundles,
    @required this.status,
  });

  factory SentenceBundleState.initial() {
    return const SentenceBundleState(
      sentenceBundles: [],
      status: SentenceBundleStateStatus.initial,
    );
  }

  @override
  List<Object> get props => [sentenceBundles, status];

  SentenceBundleState copyWith({
    List<SentenceBundle> sentenceBundles,
    SentenceBundleStateStatus status,
  }) {
    return SentenceBundleState(
      sentenceBundles: sentenceBundles ?? this.sentenceBundles,
      status: status ?? this.status,
    );
  }
}

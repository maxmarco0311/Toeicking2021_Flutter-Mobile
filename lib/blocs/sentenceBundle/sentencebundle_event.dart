part of 'sentencebundle_bloc.dart';

abstract class SentenceBundleEvent extends Equatable {
  const SentenceBundleEvent();

  @override
  List<Object> get props => [];
}

class SentenceBundleLoad extends SentenceBundleEvent {
  final String email;
  final Map<String, String> parameters;

  SentenceBundleLoad({
    @required this.email,
    @required this.parameters,
  });
  @override
  List<Object> get props => [email, parameters];
}
class SentenceBundleLoadBySentenceId extends SentenceBundleEvent {
  final String email;
  final int sentenceId;

  SentenceBundleLoadBySentenceId({
    @required this.email,
    @required this.sentenceId,
  });
  @override
  List<Object> get props => [email, sentenceId];
}

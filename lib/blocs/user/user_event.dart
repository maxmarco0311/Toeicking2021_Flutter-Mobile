part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserFetch extends UserEvent {
  final String email;
  UserFetch({
    @required this.email,
  });
  @override
  List<Object> get props => [];
}

// 加入wordList
class AddWordList extends UserEvent {
  final String email;
  final int vocabularyId;

  AddWordList({
    @required this.email,
    @required this.vocabularyId,
  });
  @override
  List<Object> get props => [email, vocabularyId];
}

// 從wordList中刪除
class DeleteWordList extends UserEvent {
  final String email;
  final int vocabularyId;

  DeleteWordList({
    @required this.email,
    @required this.vocabularyId,
  });
  @override
  List<Object> get props => [email, vocabularyId];
}

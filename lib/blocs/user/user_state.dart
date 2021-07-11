part of 'user_bloc.dart';

class UserState extends Equatable {
  final String email;
  final bool valid;
  final String rating;
  final List<int> wordList;

  const UserState({
    @required this.email,
    @required this.valid,
    @required this.rating,
    this.wordList,
  });
  factory UserState.initial() {
    return UserState(
      email: '',
      valid: false,
      rating: '0',
      wordList: [],
    );
  }
  @override
  List<Object> get props => [email, valid, rating, wordList];

  UserState copyWith({
    String email,
    bool valid,
    String rating,
    List<int> wordList,
  }) {
    return UserState(
      email: email ?? this.email,
      valid: valid ?? this.valid,
      rating: rating ?? this.rating,
      wordList: wordList ?? this.wordList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'valid': valid,
      'rating': rating,
      'wordList': wordList,
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      email: map['email'],
      valid: map['valid'],
      rating: map['rating'],
      wordList: List<int>.from(map['wordList']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));
}

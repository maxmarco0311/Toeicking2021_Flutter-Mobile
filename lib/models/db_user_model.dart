import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String email;
  final bool valid;
  final String rating;
  final List<int> wordList;

  const User(
      {@required this.email,
      @required this.valid,
      @required this.rating,
      // add或update時不需要這個屬性，所以不是required
      this.wordList});

  @override
  List<Object> get props => [email, valid, rating, wordList];

  // 將User物件轉為Map<String, dynamic>，準備轉成Json
  Map<String, dynamic> toMap() {
    return {
      // 這裡的key必須跟C#類別的屬性名稱一樣(注意大小寫)
      'Email': email,
      'Valid': valid,
      'Rating': rating,
      'WordList': wordList,
    };
  }

  // 將Json資料轉為(Dart)User物件
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      // 具名參數要自己加上去
      email: map['email'],
      valid: map['valid'],
      rating: map['rating'],
      wordList: List<int>.from(map['wordList']),
    );
  }
  // 將Map<String, dynamic>轉成Json(呼叫toMap())
  String toJson() => json.encode(toMap());

  // 參數source是response.body，是一個包含json資料的大字串
  // 要json.decode(source)才會變成Json資料，也就是Map<String, dynamic>
  // 呼叫User.fromMap()回傳(Dart)User物件
  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String email,
    bool valid,
    String rating,
    List<int> wordList,
  }) {
    return User(
      email: email ?? this.email,
      valid: valid ?? this.valid,
      rating: rating ?? this.rating,
      wordList: wordList ?? this.wordList,
    );
  }

  @override
  bool get stringify => true;
}

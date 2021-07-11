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
    // 真正的資料是在原始map中key為data的屬性值內
    Map<String, dynamic> dataMap = map['data'];
    // 要檢查dataMap['wordList']是否為null，否則null會報錯(還沒加入字彙列表就會是null)
    if (dataMap['wordList'] != null) {
      // 如果回傳GetUserDto物件，dataMap['wordList']就是List<dynamic>型別
      if (dataMap['wordList'] is List<dynamic>) {
        return User(
          // 具名參數要自己加上去
          // 轉成Json後，這裡的key都會是小寫開頭
          email: dataMap['email'],
          valid: dataMap['valid'],
          rating: dataMap['rating'],
          // 此時dataMap['wordList']可直接當List<int>.from()的參數形成List<int>
          wordList: List<int>.from(dataMap['wordList']),
        );
      }
      // 如果回傳User物件，dataMap['wordList']就是String
      else if (dataMap['wordList'] is String) {
        return User(
          email: dataMap['email'],
          valid: dataMap['valid'],
          rating: dataMap['rating'],
          // dataMap['wordList']要先強迫轉型(as String)，才可呼叫split()，此時已是List<String>
          // 再用map()將每個元素轉成int型別，記得要toList()
          wordList: (dataMap['wordList'] as String)
              .split(',')
              // ***若不用箭頭函式，要記得return!!!***
              .map((item) => int.tryParse(item))
              .toList(),
        );
      }
      // 被迫這裡也要return，不然套件會給藍字
      else {
        return User(
          email: dataMap['email'],
          valid: dataMap['valid'],
          rating: dataMap['rating'],
        );
      }
    }
    // dataMap['wordList']是否為null(如(還沒加入字彙列表時)
    else {
      return User(
        email: dataMap['email'],
        valid: dataMap['valid'],
        rating: dataMap['rating'],
      );
    }
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

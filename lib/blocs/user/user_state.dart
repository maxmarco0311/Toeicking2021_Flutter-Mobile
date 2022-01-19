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

  // 將Json資料轉為(Dart)User物件
  factory UserState.fromMap(Map<String, dynamic> map) {
    // 真正的資料是在原始map中key為data的屬性值內
    Map<String, dynamic> dataMap = map['data'];
    // 要檢查dataMap['wordList']是否為null，否則null會報錯(還沒加入字彙列表就會是null)
    if (dataMap['wordList'] != null) {
      // 如果回傳GetUserDto物件，dataMap['wordList']就是List<dynamic>型別
      if (dataMap['wordList'] is List<dynamic>) {
        return UserState(
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
        return UserState(
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
        return UserState(
          email: dataMap['email'],
          valid: dataMap['valid'],
          rating: dataMap['rating'],
        );
      }
    }
    // dataMap['wordList']為null(如還沒加入字彙列表時)
    else {
      return UserState(
        email: dataMap['email'],
        valid: dataMap['valid'],
        rating: dataMap['rating'],
      );
    }
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source));
}

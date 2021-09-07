import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/models/db_user_model.dart';
import 'package:toeicking2021/models/sentenceBundle_model.dart';
import 'package:toeicking2021/models/vocabulary_model.dart';
import 'package:toeicking2021/repositories/api/base_api_repository.dart';

class APIRepository extends BaseAPIRepository {
  APIRepository._instantiate();

  static final APIRepository instance = APIRepository._instantiate();

  // baseUrl(要去掉"https://"，否則會報錯)
  final String _baseUrl = 'api.toeicking.com';
  // header
  final Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
  };
  // 不用建構式
  // APIRepository();

  // 獲得所有SentenceBundles(GET)-->checked!
  @override
  Future<List<SentenceBundle>> getSentenceBundles({
    // email參數是讓後端檢查這個api請求的user是否為valid
    @required String email,
    Map<String, String> parameters,
  }) async {
    Uri uri = Uri.https(
      _baseUrl,
      '/Sentence/GetSentences',
      // 參數寫在呼叫處
      parameters,
    );
    var response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> sourceMap = json.decode(response.body);
      List<SentenceBundle> sentences = List<SentenceBundle>.from(
        // 真正的資料是在原始map中key為data的屬性值內，所以要先處理成sourceMap['data']
        sourceMap['data']?.map(
          (sentenceBundleMap) => SentenceBundle.fromMap(sentenceBundleMap),
        ),
      );
      return sentences;
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 獲得字彙列表
  @override
  Future<List<Vocabulary>> getWordList({
    String pageToLoad,
    String pageSize,
    String email,
  }) async {
    Uri uri = Uri.https(
      _baseUrl,
      '/Vocabulary/GetVocabularies',
    );
    var response = await http.post(
      uri,
      headers: _headers,
      body: json.encode(
        {
          'PageToLoad': pageToLoad,
          'PageSize': pageSize,
          'Email': email,
        },
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> sourceMap = json.decode(response.body);
      List<Vocabulary> vocabularies = List<Vocabulary>.from(
        // 真正的資料是在原始map中key為data的屬性值內，所以要先處理成sourceMap['data']
        sourceMap['data']?.map(
          (vocabularyMap) => Vocabulary.fromMap(vocabularyMap),
        ),
      );
      return vocabularies;
    } else {
      print(Exception().toString());
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 新增使用者資料(POST)-->checked!
  @override
  Future<User> addUser({User user}) async {
    Uri uri = Uri.https(_baseUrl, '/User/Add');
    var response = await http.post(
      uri,
      headers: _headers,
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 獲得使用者資料(GET)-->checked!
  @override
  Future<UserState> getUser({String email}) async {
    // 參數範例：{'FormData.Keyword': 'absolutely'}
    // 參數範例：{'C#物件屬性名稱': 值}
    Uri uri = Uri.https(
      _baseUrl,
      '/User/GetUser',
      // 參數直接寫在Map裡
      {'email': email},
    );
    var response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      print('api getUser: ${response.body}');
      // 直接裝回UserState物件
      return UserState.fromJson(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 更新使用者資料(POST)-->checked!
  @override
  Future<User> updateUser({@required User user}) async {
    Uri uri = Uri.https(_baseUrl, '/User/Update');
    var response = await http.post(
      uri,
      headers: _headers,
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 加入WordList(POST)-->checked!(第一次加入原本有bug，已解掉)
  @override
  Future<UserState> addWordList({String email, String vocabularyId}) async {
    Uri uri = Uri.https(_baseUrl, '/User/AddWordList');
    var response = await http.post(
      uri,
      headers: _headers,
      // body要傳送的資料沒有包成物件，就直接寫成Map給json.encode()處理成Json字串
      // 注意key要寫成跟C#物件屬性名稱完全一樣(注意大小寫)
      body: json.encode(
        {'Email': email, 'VocabularyId': vocabularyId},
      ),
    );
    if (response.statusCode == 200) {
      return UserState.fromJson(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

// 從WordList中刪除(POST)
  @override
  Future<UserState> deleteWordList({String email, String vocabularyId}) async {
    Uri uri = Uri.https(_baseUrl, '/User/DeleteWordList');
    var response = await http.post(
      uri,
      headers: _headers,
      // body要傳送的資料沒有包成物件，就直接寫成Map給json.encode()處理成Json字串
      // 注意key要寫成跟C#物件屬性名稱完全一樣(注意大小寫)
      body: json.encode(
        {'Email': email, 'VocabularyId': vocabularyId},
      ),
    );
    if (response.statusCode == 200) {
      return UserState.fromJson(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 依字彙編號取得sentenceBundle(GET)-->checked!
  @override
  Future<SentenceBundle> getSentenceBundleByVocabularyId(
      {String email, String vocabularyId}) async {
    Uri uri = Uri.https(
      _baseUrl,
      '/Sentence/GetSentenceByVocabularyId',
      {'Email': email, 'VocabularyId': vocabularyId},
    );
    var response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> sourceMap = json.decode(response.body);
      // 真正的資料是在原始map中key為data的屬性值內，所以要先處理成sourceMap['data']
      // 然後呼叫fromMap()不是fromJson()
      return SentenceBundle.fromMap(sourceMap['data']);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 依句子編號取得sentenceBundle(GET)
  @override
  Future<SentenceBundle> getSentenceBundleBySentenceId(
      {String email, String sentenceId}) async {
    // ***Uri.https()的queryParameters似乎只接受Map<String, String>，int會報錯!***
    Uri uri = Uri.https(
      _baseUrl,
      '/Sentence/GetSentenceBySentenceId',
      {'Email': email, 'SentenceId': sentenceId},
    );
    var response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> sourceMap = json.decode(response.body);
      print(sourceMap.toString());
      // 真正的資料是在原始map中key為data的屬性值內，所以要先處理成sourceMap['data']
      // 然後呼叫fromMap()不是fromJson()
      return SentenceBundle.fromMap(sourceMap['data']);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }

  // 檢查Email是否存在
  @override
  Future<bool> checkEmail({String email}) async {
    Uri uri = Uri.https(_baseUrl, '/User/IsEmailExist');
    var response = await http.post(
      uri,
      headers: _headers,
      // body要傳送的資料沒有包成物件，就直接寫成Map給json.encode()處理成Json字串
      // ***但C#端一定要將資料包成一個物件當API參數***
      // 注意key要寫成跟C#物件屬性名稱完全一樣(注意大小寫)
      body: json.encode({'Email': email}),
    );
    if (response.statusCode == 200) {
      // 因為只有回傳bool，所以不需要用物件的fromMap()
      return json.decode(response.body);
    } else {
      throw Exception('出現無法預期錯誤，請稍後再試');
    }
  }
}

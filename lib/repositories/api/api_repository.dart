import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:toeicking2021/models/sentenceBundle_model.dart';
import 'package:toeicking2021/repositories/api/base_api_repository.dart';

class APIRepository extends BaseAPIRepository {
  APIRepository._instantiate();

  static final APIRepository instance = APIRepository._instantiate();

  // baseUrl中要去掉"https://"，否則會報錯
  final String _baseUrl = 'api.toeicking.com';

  APIRepository();

  @override
  Future<List<SentenceBundle>> getSentenceBundles({
    @required String email,
    Map<String, String> parameters,
  }) async {
    Uri uri = Uri.https(
      _baseUrl,
      '/Sentence/GetSentences',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> sourceMap = json.decode(response.body);
    List<SentenceBundle> sentences = List<SentenceBundle>.from(
      sourceMap['data']?.map(
        (sentenceBundleMap) => SentenceBundle.fromMap(sentenceBundleMap),
      ),
    );
    return sentences;
  }
}

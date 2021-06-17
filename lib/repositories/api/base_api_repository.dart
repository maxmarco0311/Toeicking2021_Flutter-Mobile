import 'package:toeicking2021/models/models.dart';

abstract class BaseAPIRepository {
  Future<List<SentenceBundle>> getSentenceBundles(
      {String email, Map<String, String> parameters});
}

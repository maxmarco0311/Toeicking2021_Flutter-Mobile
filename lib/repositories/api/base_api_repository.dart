import 'package:toeicking2021/models/models.dart';

abstract class BaseAPIRepository {
  Future<List<SentenceBundle>> getSentenceBundles(
      {String email, Map<String, String> parameters});
  Future<User> addUser({User user});
  Future<User> getUser({String email});
  Future<User> updateUser({User user});
  Future<User> addWordList({String email, String vocabularyId});
  Future<SentenceBundle> getSentenceBundleByVocabularyId(
      {String email, String vocabularyId});
}

import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/models/models.dart';

abstract class BaseAPIRepository {
  Future<List<SentenceBundle>> getSentenceBundles(
      {String email, Map<String, String> parameters});
  Future<User> addUser({User user});
  Future<UserState> getUser({String email});
  Future<User> updateUser({User user});
  Future<UserState> addWordList({String email, String vocabularyId});
  Future<UserState> deleteWordList({String email, String vocabularyId});
  Future<SentenceBundle> getSentenceBundleByVocabularyId(
      {String email, String vocabularyId});
  Future<SentenceBundle> getSentenceBundleBySentenceId(
      {String email, int sentenceId});
  Future<bool> checkEmail({String email});
}

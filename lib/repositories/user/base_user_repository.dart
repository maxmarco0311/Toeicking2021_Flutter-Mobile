import 'package:toeicking2021/models/models.dart';

abstract class BaseUserRepository {
  Future<AuthUser> getUserWithId({String userId});
  Future<bool> isEmailExist({String email});
  Future<void> updateUser({AuthUser user});
  Future<List<AuthUser>> searchUsers({String query});
  void followUser({String userId, String followUserId});
  void unfollowUser({String userId, String unfollowUserId});
  Future<bool> isFollowing({String userId, String otherUserId});
}

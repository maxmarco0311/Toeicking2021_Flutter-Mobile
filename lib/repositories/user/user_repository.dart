import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/config/paths.dart';
import 'package:toeicking2021/models/models.dart';

import '../repositories.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  // 根據userId找出Firestore中的user物件資料，回傳承自訂user物件
  Future<AuthUser> getUserWithId({@required String userId}) async {
    // doc(userId)回傳DocumentReference物件，get()回傳Future<DocumentSnapshot>
    // 用await即可取得該DocumentSnapshot物件
    // 再呼叫User.fromDocument(doc)即可裝成自訂user物件
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? AuthUser.fromDocument(doc) : AuthUser.empty;
  }

  @override
  // 根據自訂User物件更新Firestore中的user物件
  Future<void> updateUser({@required AuthUser user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        // 使用自訂User物件中的id屬性去找出DocumentReference
        .doc(user.id)
        // update()參數為Map<String, dynamic>，所以呼叫該User類別的toDocument()
        .update(user.toDocument());
  }

  @override
  // 搜尋user，參數為文字框輸入的文字
  Future<List<AuthUser>> searchUsers({@required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        // 條件查詢
        .where('username', isGreaterThanOrEqualTo: query)
        // get()獲得Future<QuerySnapshot>，snapshots()獲得Stream<QuerySnapshot>
        // 使用await呼叫，所以實際回傳的是QuerySnapshot
        .get();
    // userSnap.docs回傳List<QueryDocumentSnapshot>
    // 利用map()方法將每一個QueryDocumentSnapshot換成User物件，並形成集合回傳
    return userSnap.docs.map((doc) => AuthUser.fromDocument(doc)).toList();
  }

  @override
  // 追蹤user，然後下一步給cloud function處理
  void followUser({
    // userId為"追蹤他人者"的ID
    @required String userId,
    // followUserId為"被追蹤者"的ID
    @required String followUserId,
  }) {
    // 1. 將"被追蹤者的ID"加入"追蹤者"的userFolllowing資料表(following資料表-->userFollowing資料表)
    _firebaseFirestore
        .collection(Paths.following)
        // 找到資料表中自己(userId)的那一筆document
        .doc(userId)
        // 再進入userFollowing資料表"欄位"
        .collection(Paths.userFollowing)
        // 指定使用followUserId建立一筆document
        .doc(followUserId)
        // 使用set({})將該筆document填入資料，但參數是空Map，所以實際沒有填任何資料進去
        // 若使用set({})時，該筆document已經有資料，元有資料會被覆蓋
        .set({});

    // 2. 將"追蹤者的ID"加入"被追蹤者"的userFolllower資料表(followers資料表-->userFollowers資料表)
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});

    // 3. 將Notification物件存進資料庫：
    // 將資料裝進Notif()物件
    // final notification = Notif(
    //   // NotifType列舉值為follow
    //   type: NotifType.follow,
    //   // 在followUser()方法中沒有user的其他資料，所以就實體化一個空User物件，只傳入userId
    //   // 這裡的userId為"追蹤他人者"的ID
    //   fromUser: User.empty.copyWith(id: userId),
    //   date: DateTime.now(),
    // );
    // 將Notif()物件存進資料庫
    // _firebaseFirestore
    //     .collection(Paths.notifications)
    //     .doc(followUserId)
    //     .collection(Paths.userNotifications)
    //     .add(notification.toDocument());
  }

  @override
  // 取消追蹤user，然後下一步給cloud function處理
  void unfollowUser({
    // userId為"取消追蹤者"的ID
    @required String userId,
    // unfollowUserId為"被取消追蹤者"的ID
    @required String unfollowUserId,
  }) {
    // 1. 將"被取消追蹤的ID"的那筆document從"取消追蹤者"的userFolllowing資料表中刪除(following資料表-->userFollowing資料表)
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        // 將該筆document刪除
        .delete();
    // 2. 將"取消追蹤者的ID"的那筆document從"被取消追蹤者"的userFolllower資料表中刪除(followers資料表-->userFollowers資料表)
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  // 檢查是否有追蹤某位user
  Future<bool> isFollowing({
    // 自己的ID
    @required String userId,
    // 某位user的ID
    @required String otherUserId,
  }) async {
    // 檢查自己的的ID是否有在某位user的userFollowing資料表中
    final otherUserDoc = await _firebaseFirestore
        // 先進入到following資料表
        .collection(Paths.following)
        // 找到自己ID的那筆document
        .doc(userId)
        // 再進入userFollowing資料表"欄位"
        .collection(Paths.userFollowing)
        // 找到某位user的ID的那筆document
        .doc(otherUserId)
        // 用get()取得DocumentSnapshot物件
        .get();
    // 使用exists屬性判斷這筆document是否存在(也有data()取得Map型別的該筆全部資料)
    return otherUserDoc.exists;
  }
}

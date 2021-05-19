import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/config/paths.dart';
import 'package:toeicking2021/models/failure_model.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore firebaseFirestore,
    auth.FirebaseAuth firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  // 用user(getter)取得Firebase user狀態變化的stream
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  @override
  // 註冊的方法
  Future<auth.User> signUpWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      // 用email及password建立user
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 用credential.user取得Firebase User物件--> user
      final user = credential.user;
      // 寄信驗證email
      // 1. dynamic link設定
      var actionCodeSettings = ActionCodeSettings(
          // deeplink：dynamic link要導向的位置，必須是一個實際的網址，可帶參數，之後可解析
          url: 'https://www.example.com/?email=${user.email}',
          // default prefix of a dynamic link：也可用自己設定的(通常改example那部份)
          dynamicLinkDomain: "example.page.link",
          // 專案的android id，必須與firebase project綁定的一樣
          androidPackageName: "com.example.android",
          androidInstallApp: true,
          androidMinimumVersion: "12",
          // 專案的ios id，必須與firebase project綁定的一樣
          iOSBundleId: "com.example.ios",
          handleCodeInApp: true);
      // 2. 寄出信件
      user.sendEmailVerification(actionCodeSettings);
      _firebaseAuth.currentUser.reload();
      // 將使用者資料存進資料庫：
      // 1. 用Firebase User物件的uid屬性(user id)當document id
      // 2. doc(user.uid)-->使用特定值當document id
      // 3. 用set()將值寫入，參數為Map<String, dynamic>
      _firebaseFirestore.collection(Paths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      // 要在這裡處理各種例外錯誤
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  // 登入的方法
  Future<auth.User> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on auth.FirebaseAuthException catch (err) {
      // 要在這裡處理各種例外錯誤(無效email、email沒有註冊、密碼錯誤等)
      throw Failure(code: err.code, message: err.message);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message);
    }
  }

  @override
  // 登出的方法
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}

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
  Future<auth.User> signUpWithEmailAndPassword({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      var actionCodeSettings = ActionCodeSettings(
          url: 'https://toeicking.com/dynamiclink/index?email=test',
          dynamicLinkDomain: 'toeicking.page.link',
          androidPackageName: 'com.example.toeicking2021',
          androidInstallApp: true,
          androidMinimumVersion: '12',
          // iOSBundleId: 'com.example.ios',
          handleCodeInApp: true);
      await user.sendEmailVerification(actionCodeSettings);
      // await user.sendEmailVerification();
      await _firebaseAuth.currentUser.reload();
      _firebaseFirestore.collection(Paths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
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

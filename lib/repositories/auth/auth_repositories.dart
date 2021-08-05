import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/config/paths.dart';
import 'package:toeicking2021/models/failure_model.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/utilities/translate_exception_error.dart';

import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;
  final LocalDataRepository _localDataRepository;

  AuthRepository({
    FirebaseFirestore firebaseFirestore,
    auth.FirebaseAuth firebaseAuth,
    LocalDataRepository localDataRepository,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _localDataRepository =
            localDataRepository ?? LocalDataRepository.instance;

  @override
  // 用user(getter)取得Firebase user狀態變化的stream
  Stream<auth.User> get user => _firebaseAuth.userChanges();

  auth.User get getCurrentUser => _firebaseAuth.currentUser;

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
      // var actionCodeSettings = ActionCodeSettings(
      //     url: 'https://toeicking.com/dynamiclink/index?email=test',
      //     dynamicLinkDomain: 'toeicking.page.link',
      //     androidPackageName: 'com.example.toeicking2021',
      //     androidInstallApp: true,
      //     androidMinimumVersion: '12',
      //     // iOSBundleId: 'com.example.ios',
      //     handleCodeInApp: true);
      // await user.sendEmailVerification(actionCodeSettings);

      // 寄出驗證信
      await user.sendEmailVerification();
      // 將使用者資料存進firestore
      _firebaseFirestore.collection(Paths.users).doc(user.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });
      // 先檢查sqlite資料表裡是否已有資料，以防萬一有人用不同帳號在同一個手機登入
      final row = await _localDataRepository.getLocalAudioSettingState();
      print('row not empty: ${row.isNotEmpty}');
      // 資料表裡沒資料再將播放初始值存入
      if (!row.isNotEmpty) {
        // 將預設的audioSetting存進sqlite
        Map<String, dynamic> map = {
          'accent': 'GB',
          'gender': 'M',
          'rate': '1.0',
          'repeatedTimes': 0
        };
        _localDataRepository.insertLocalAudioSettingState(map);
        print('insert default value!!!');
      }

      // 回傳firebase user
      return user;
    } on auth.FirebaseAuthException catch (err) {
      print('error code: ${err.code}\n error message: ${err.message}');
      // 要在這裡處理各種例外錯誤(無效email、email沒有註冊、密碼錯誤等)
      // 先寫個類別將err.code轉成對應的中文錯誤訊息字串，再將該字串傳入Failure物件(傳一個字串就好)
      // Failure物件(類別本身和註冊登入的cubit)以及ErrorDialog物件(類別本身)要修改
      // 參考https://gist.github.com/nikhilmufc7/6b74a3c12a6e2d3284942d40ff583e37
      String errorMessage = TranslateExceptionError.authException(err.code);
      throw Failure(message: errorMessage);
    } on PlatformException catch (err) {
      print('error code: ${err.code}\n error message: ${err.message}');
      // 參考https://github.com/flutter/flutter/issues/20223#issue-347613208
      String errorMessage = Platform.isIOS
          ? TranslateExceptionError.platformException(err.code)
          : TranslateExceptionError.platformException(err.message);
      throw Failure(message: errorMessage);
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
      print('error code: ${err.code}\n error message: ${err.message}');
      // 要在這裡處理各種例外錯誤(無效email、email沒有註冊、密碼錯誤等)
      String errorMessage = TranslateExceptionError.authException(err.code);
      throw Failure(message: errorMessage);
    } on PlatformException catch (err) {
      print('error code: ${err.code}\n error message: ${err.message}');
      String errorMessage = Platform.isIOS
          ? TranslateExceptionError.platformException(err.code)
          : TranslateExceptionError.platformException(err.message);
      throw Failure(message: errorMessage);
    }
  }

  @override
  // 登出的方法
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}

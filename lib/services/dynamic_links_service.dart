import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:toeicking2021/main.dart';

class DynamicLinkService {
  // 建立FirebaseAuth實體
  FirebaseAuth auth = FirebaseAuth.instance;
  // 檢查驗證信動態連結回傳的actionCode，完成註冊程序
  Future<void> _verifyEmail(Uri deepLink) async {
    var actionCode = deepLink.queryParameters['oobCode'];
    try {
      await auth.checkActionCode(actionCode);
      await auth.applyActionCode(actionCode);
      // If successful, reload the user:
      auth.currentUser.reload();
      // 導向到nav_screen

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-action-code') {
        print('The code is invalid.');
      }
    }
  }

  // 接收dynamicLink的方法(context參數是用在Navigator轉導)
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      // 兩種取得dynamic link的情境：
      // 1. 若APP沒打開，透過dynamic link打開時會呼叫getInitialLink()
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      // 透過data?.link取得deeplink
      final Uri deepLink = data?.link;

      // 檢查deepLink不是null
      if (deepLink != null) {
        // ***deeplink參數處理***
        // 1. 檢查動態連結參數的name是否有'id'-->範例
        if (deepLink.queryParameters.containsKey('id')) {
          // 2. 再用deepLink.queryParameters['參數的name']取得參數值
          String id = deepLink.queryParameters['id'];
          print(id);
        }
        // 2. 動態連結參數的name有'email'代表從驗證信中的動態連結導回App
        else if (deepLink.queryParameters.containsKey('email')) {
          await _verifyEmail(deepLink);
        }
        // 導向到某一頁
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      }
      // 2. 若APP有打開在背景中，透過dynamic link打開時會呼叫onLink()
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // 會自動傳入dynamicLink變數，其實就等同與上面data變數，可以自訂一個處理方法
          final Uri deepLink = dynamicLink?.link;
          if (deepLink.queryParameters.containsKey('email')) {
            await _verifyEmail(deepLink);
          }
          // 將這兩個變數丟進去，用data?.link取得實際的deeplink，再看要如何處理
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );
        },
        // 印出錯誤訊息
        onError: (OnLinkErrorException e) async {
          print('Link Failed: ${e.message}');
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // 自己生dynamic link(無參數)
  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://your.page.link',
      link: Uri.parse('https://your.url.com'),
      androidParameters: AndroidParameters(
        packageName: 'your_android_package_name',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  // 自己生dynamic link(有參數)
  Future<Uri> createDynamicLinkWithParams(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://your.page.link',
      link: Uri.parse('https://{your URL}.com/?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'your_android_package_name',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    return dynamicUrl;
  }
}

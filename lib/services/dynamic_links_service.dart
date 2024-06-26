import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:toeicking2021/screens/screens.dart';

class DynamicLinkService {
  // 建立FirebaseAuth實體
  FirebaseAuth auth = FirebaseAuth.instance;
  // 檢查驗證信動態連結回傳的actionCode，完成註冊程序
  Future<void> _verifyEmail(BuildContext context, Uri deepLink) async {
    print('_verifyEmail called');
    print('deepLink in _verifyEmail：$deepLink');
    var actionCode = deepLink.queryParameters['oobCode'];
    print('actionCode: $actionCode');
    // 要用pushNamed，不能用push，因為builder的context不一樣，會報錯
    Navigator.of(context).pushNamed(SignupScreen.routeName);
    try {
      await auth.checkActionCode(actionCode);
      await auth.applyActionCode(actionCode);
      // If successful, reload the user:
      auth.currentUser.reload();
      // 導向到nav_screen--> 可能不用導

    } on FirebaseAuthException catch (e) {
      print('code: ${e.code.toString()}, message: ${e.message.toString()}');
      // if (e.code == 'invalid-action-code') {
      //   print('The code is invalid.');
      // }
    }
  }

  // 接收dynamicLink的方法(context參數是用在Navigator轉導)
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      print('retrieveDynamicLink called!');
      // 兩種取得dynamic link的情境：
      // (1) 若APP沒打開，透過dynamic link打開時會呼叫getInitialLink():
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      // 透過data?.link取得deeplink
      final Uri deepLink = data?.link;
      print('deepLink in getInitialLink: $deepLink');
      // 檢查deepLink不是null
      if (deepLink != null) {
        print('getInitialLink called');
        // ***deeplink參數情境處理***
        print('containsKey: ${deepLink.queryParameters.containsKey('email')}');
        // 1. 檢查動態連結參數的name是否有'id'-->範例
        if (deepLink.queryParameters.containsKey('id')) {
          // 再用deepLink.queryParameters['參數的name']取得參數值
          String id = deepLink.queryParameters['id'];
          print(id);
        }
        // 2. 動態連結參數的name有'email'代表從驗證信中的動態連結導回App
        else if (deepLink.queryParameters.containsKey('email')) {
          print('_verifyEmail in getInitialLink called');
          await _verifyEmail(context, deepLink);
        } else {
          Navigator.of(context).pushNamed(SignupScreen.routeName);
        }
      }
      // (2) 若APP有打開在背景中，透過dynamic link打開時會呼叫onLink():
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print('onLink called');
          // 會自動傳入dynamicLink變數，其實就等同與上面data變數，可以自訂一個處理方法
          final Uri deepLink = dynamicLink?.link;
          print('deepLink in onLink: $deepLink');
          print(
              'containsKey: ${deepLink.queryParameters.containsKey('email')}');
          if (deepLink.queryParameters.containsKey('email')) {
            print('_verifyEmail in onLink called');
            await _verifyEmail(context, deepLink);
          } else {
            Navigator.of(context).pushNamed(SignupScreen.routeName);
          }
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

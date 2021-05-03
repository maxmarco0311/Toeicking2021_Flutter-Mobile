import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:toeicking2021/main.dart';

class DynamicLinkService {
  // 接收dynamicLink的方法(context參數是用在Navigator轉導)
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          // 若APP沒打開，透過dynamic link打開時會呼叫getInitialLink()
          await FirebaseDynamicLinks.instance.getInitialLink();
      // 透過data?.link取得deeplink
      final Uri deepLink = data?.link;

      // 檢查deepLink不是null
      if (deepLink != null) {
        // deeplink有參數的話在這裡處理
        // 1. 先搜尋是否有參數的name字串
        if (deepLink.queryParameters.containsKey('id')) {
          // 2. 再用deepLink.queryParameters['參數的name']取得參數值
          String id = deepLink.queryParameters['id'];
          print(id);
        }
        // 導向到某一頁
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      }
      // 若APP有打開在背景中，透過dynamic link打開時會呼叫onLink()
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // 會自動傳入dynamicLink變數，其實就等同與上面data變數，可以自訂一個處理方法
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

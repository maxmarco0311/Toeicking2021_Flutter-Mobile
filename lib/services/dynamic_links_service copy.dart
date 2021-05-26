import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:toeicking2021/screens/screens.dart';

class DynamicLinkService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      print('retrieveDynamicLink called!');

      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
      print('deepLink in getInitialLink: $deepLink');
      if (deepLink != null) {
        print('getInitialLink called');
        print('containsKey: ${deepLink.queryParameters.containsKey('email')}');
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          print(id);
        } else if (deepLink.queryParameters.containsKey('email')) {
          print('_verifyEmail in getInitialLink called');
          await _verifyEmail(context, deepLink);
        } else {
          Navigator.of(context).pushNamed(SignupScreen.routeName);
        }
      }

      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print('onLink called');
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
        onError: (OnLinkErrorException e) async {
          print('Link Failed: ${e.message}');
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _verifyEmail(BuildContext context, Uri deepLink) async {
    print('_verifyEmail called');
    print('deepLink in _verifyEmail：$deepLink');
    var actionCode = deepLink.queryParameters['oobCode'];
    print('actionCode: $actionCode');
    Navigator.of(context).pushNamed(SignupScreen.routeName);
    try {
      await auth.checkActionCode(actionCode);
      await auth.applyActionCode(actionCode);
      auth.currentUser.reload();
    } on FirebaseAuthException catch (e) {
      print('code: ${e.code.toString()}, message: ${e.message.toString()}');
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

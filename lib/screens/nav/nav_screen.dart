import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/widgets/centered_text.dart';

import 'cubit/bottom_nav_bar_cubit.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    // PageRouteBuilder是可以設計動畫的換頁，這裡利用transitionDuration為0
    // 讓此頁是感覺疊加在SplashScreen上出現，MaterialPageRoute頁面是由側邊滑入的
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: NavScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('導航頁'),
          centerTitle: true,
          // 隱藏回上一頁
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                // 登出
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: CenteredText(text: '進入導航頁'),
      ),
    );
  }
}

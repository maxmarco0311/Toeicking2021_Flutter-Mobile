import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/blocs/blocs.dart';
// import 'package:toeicking2021/repositories/api/api_repository.dart';
import 'package:toeicking2021/widgets/centered_text.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class ModeScreen extends StatefulWidget {
  static const String routeName = '/mode';

  // static Route route() {
  //   // PageRouteBuilder是可以設計動畫的換頁，這裡利用transitionDuration為0
  //   // 讓此頁是感覺疊加在SplashScreen上出現，MaterialPageRoute頁面是由側邊滑入的
  //   return PageRouteBuilder(
  //     settings: const RouteSettings(name: routeName),
  //     transitionDuration: const Duration(seconds: 0),
  //     pageBuilder: (BuildContext context, __, ___) =>
  //         BlocProvider<SentenceBundleBloc>(
  //       create: (_) => SentenceBundleBloc(
  //         apiRepository: context.read<APIRepository>(),
  //         // 頁面建立時建立SentenceBundleBloc，SentenceBundleBloc建立時觸發SentenceBundleLoad事件
  //       )..add(
  //           SentenceBundleLoad(
  //             email: 'maxmarco0311@gmail.com',
  //             // 參數範例：{'FormData.Keyword': 'absolutely'}
  //             parameters: {},
  //           ),
  //         ),
  //       child: ModeScreen(),
  //     ),
  //   );
  // }

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('學習模式'),
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
      body: BlocBuilder<SentenceBundleBloc, SentenceBundleState>(
        builder: (context, state) {
          switch (state.status) {
            case SentenceBundleStateStatus.error:
              return CenteredText(text: '學習模式');
            case SentenceBundleStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            // 預設狀態是顯示資料
            default:
              // ListView要設Padding，不然內容太靠近螢幕
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 20.0,
                ),
                child: ListView.builder(
                  itemCount: state.sentenceBundles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sentenceBundle = state.sentenceBundles[index];
                    // 將ListTile獨立出來
                    return SentenceTile(sentenceBundle: sentenceBundle);
                  },
                ),
              );
          }
          // return CenteredText(text: '進入導航頁');
        },
      ),
    );
  }
}

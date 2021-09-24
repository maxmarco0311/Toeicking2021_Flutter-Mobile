import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/repositories/api/api_repository.dart';
import 'package:toeicking2021/screens/mode/mode_screen.dart';
import 'package:toeicking2021/widgets/centered_text.dart';
import 'package:toeicking2021/widgets/widgets.dart';

// 路由參數
class ModeResultScreenArgs {
  // 查詢條件的Map
  final Map<String, String> searchConditions;
  ModeResultScreenArgs({
    @required this.searchConditions,
  });
}

class ModeResultScreen extends StatefulWidget {
  static const String routeName = '/mode_result';
  // 在onGenerateNestedRoute內運作，要寫route()方法
  static Route route({@required ModeResultScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SentenceBundleBloc>(
        create: (_) => SentenceBundleBloc(
          apiRepository: context.read<APIRepository>(),
        )..add(
            SentenceBundleLoad(
              email: context.read<AuthBloc>().state.user.email,
              // 參數範例：{'FormData.Keyword': 'absolutely'}
              parameters: args.searchConditions,
            ),
          ),
        child: ModeResultScreen(),
      ),
    );
  }

  const ModeResultScreen({
    Key key,
  }) : super(key: key);

  @override
  _ModeResultScreenState createState() => _ModeResultScreenState();
}

class _ModeResultScreenState extends State<ModeResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜尋結果'),
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
          IconButton(
            onPressed: () {
              // 回到ModeScreen()，開發階段用，之後要刪掉
              Navigator.of(context).pushNamed(ModeScreen.routeName);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
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
              // 顯示頁面捲軸位置
              return Scrollbar(
                // 不滑動時也顯示捲軸位置
                isAlwaysShown: true,
                // hover時顯示整根捲軸
                showTrackOnHover: true,
                // 捲軸位置線條寬度
                thickness: 5.0,
                child: ListView.builder(
                  // ListView要設Padding，不然內容太靠近螢幕
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 20.0,
                  ),
                  itemCount: state.sentenceBundles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sentenceBundle = state.sentenceBundles[index];
                    // final bloc = context.read<SentenceBundleBloc>();
                    // 將ListTile獨立出來-->SentenceTile()還要傳入user資料
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

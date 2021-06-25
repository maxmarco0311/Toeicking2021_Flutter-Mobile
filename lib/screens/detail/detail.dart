import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/widgets/widgets.dart';

// 透過路由參數把SentenceBundle物件傳進來
class DetailScreenArgs {
  final SentenceBundle sentenceBundle;
  DetailScreenArgs({
    @required this.sentenceBundle,
  });
}

class DetailScreen extends StatelessWidget {
  final SentenceBundle sentenceBundle;
  const DetailScreen({
    Key key,
    @required this.sentenceBundle,
  }) : super(key: key);
  static const String routeName = '/signup';

  static Route route({@required DetailScreenArgs args}) {
    // 註冊頁可以側滑顯示，所以用MaterialPageRoute()
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      // 若bloc或cubit只限這一頁使用，可在builder屬性值註冊BlocProvider<T>()
      builder: (context) => BlocProvider<AudioSettingCubit>(
        create: (_) => AudioSettingCubit(),
        child: DetailScreen(sentenceBundle: args.sentenceBundle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('播放器測試'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(),
            BlocBuilder<AudioSettingCubit, AudioSettingState>(
              builder: (context, state) {
                return Expanded(
                  child: Player(
                    sentenceId: '${sentenceBundle.sentence.sentenceId}',
                    url: _getUrlBySetting(),
                    // 要把顯示bottomsheet的callback function傳給Player()
                    onSetting: _showAudioSetting(context, state),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getUrlBySetting() {
    return '';
  }

  VoidCallback _showAudioSetting(
      BuildContext context, AudioSettingState state) {
    final cubit = context.read<AudioSettingCubit>();
    return () {
      showModalBottomSheet(
        context: context,
        builder: (_) => BottomSheetContent(
          context: context,
          state: state,
          cubit: cubit,
        ),
      );
    };
  }
}

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
  static const String routeName = '/detail';

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(),
              ],
            ),
          ),
          BlocBuilder<AudioSettingCubit, AudioSettingState>(
            builder: (context, state) {
              return Player(
                sentenceId: '${sentenceBundle.sentence.sentenceId}',
                url: _getUrlBySetting(state),
                // 要把顯示bottomsheet的callback function傳給Player()
                onSetting: _showAudioSetting(context, state),
                // repeatedTimes: 5,
              );
            },
          ),
        ],
      ),
    );
  }

  // 根據AudioSettingState獲得url字串
  String _getUrlBySetting(AudioSettingState state) {
    String urlDicKey = state.accent + state.gender;
    String url = '';
    switch (state.rate) {
      case '0.75':
        url = sentenceBundle.slowAudioUrls[urlDicKey];
        break;
      case '1.0':
        url = sentenceBundle.normalAudioUrls[urlDicKey];
        break;
      case '1.25':
        url = sentenceBundle.fastAudioUrls[urlDicKey];
        break;
      default:
        url = '';
    }
    return url;
  }

  // 打開bottom sheet的函式，要傳入Player()
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

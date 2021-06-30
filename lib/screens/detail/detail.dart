// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/custom_packages/packages.dart';
import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/widgets/widgets.dart';

// 路由參數：SentenceBundle物件
class DetailScreenArgs {
  final SentenceBundle sentenceBundle;
  DetailScreenArgs({
    @required this.sentenceBundle,
  });
}

class DetailScreen extends StatefulWidget {
  final SentenceBundle sentenceBundle;
  const DetailScreen({
    Key key,
    @required this.sentenceBundle,
  }) : super(key: key);
  // 路由字串
  static const String routeName = '/detail';
  // 回傳路由(要傳入路由參數所屬"類別"物件args)
  static Route route({@required DetailScreenArgs args}) {
    // 可以側滑顯示，所以用MaterialPageRoute()
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
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // ExpandableBottomSheetStaten所需的key
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  // 判斷箭頭圖示
  bool isArrowDown = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('播放器測試'),
        centerTitle: true,
      ),
      // ExpandableBottomSheet()物件要放在body屬性值
      body: ExpandableBottomSheet(
        // 要有key
        key: key,
        // 下拉"到底"會觸發的callback
        onIsContractedCallback: () => setState(() {
          isArrowDown = false;
        }),
        // 上拉"到底"會觸發的callback
        onIsExtendedCallback: () => setState(() {
          isArrowDown = true;
        }),
        // 點按header會toggle
        enableToggle: true,
        // background屬性值是此頁"非上下拉部份"的widget
        background: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(),
                ],
              ),
            ),
          ],
        ),
        // header部份的widget
        persistentHeader: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            // 如果要設decoration屬性，就得把color屬性放進BoxDecoration()裡，否則會報錯
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 使用SizedBox()包住chidren widget，並設定高度後是去掉原有padding的方式
              SizedBox(
                height: 45.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: isArrowDown
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 40.0,
                          ),
                          onPressed: () => key.currentState.contract(),
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            size: 40.0,
                          ),
                          onPressed: () => key.currentState.expand(),
                        ),
                ),
              ),
              SizedBox(
                height: 15.0,
                child: Divider(color: Colors.grey.shade900),
              ),
            ],
          ),
        ),
        // 可收合部份的widget
        expandableContent: BlocBuilder<AudioSettingCubit, AudioSettingState>(
          builder: (context, state) {
            return Player(
              sentenceId: '${widget.sentenceBundle.sentence.sentenceId}',
              url: _getUrlBySetting(state),
              // 要把顯示bottomsheet的callback function傳給Player()
              onSetting: _showAudioSetting(context, state),
              // 傳入state
              state: state,
            );
          },
        ),
      ),
    );
  }

  // 獲得url字串
  String _getUrlBySetting(AudioSettingState state) {
    String urlDicKey = state.accent + state.gender;
    String url = '';
    switch (state.rate) {
      case '0.75':
        url = widget.sentenceBundle.slowAudioUrls[urlDicKey];
        break;
      case '1.0':
        url = widget.sentenceBundle.normalAudioUrls[urlDicKey];
        break;
      case '1.25':
        url = widget.sentenceBundle.fastAudioUrls[urlDicKey];
        break;
      default:
        url = '';
    }
    return url;
  }

  // 打開ModalBottomSheet的方法
  VoidCallback _showAudioSetting(
      BuildContext context, AudioSettingState state) {
    final cubit = context.read<AudioSettingCubit>();
    // 回傳callback function(VoidCallback型別)
    return () {
      showModalBottomSheet(
        enableDrag: true,
        // 鍵盤不擋住bottom sheet的步驟：
        // 1. 設此屬性
        isScrollControlled: true,
        // 點按不能關bottom sheet
        // isDismissible: false,
        // 圓角用RoundedRectangleBorder()就好
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
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

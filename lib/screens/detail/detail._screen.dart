// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toeicking2021/custom_packages/packages.dart';
import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/repositories.dart';
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
  // 給onGenerateNestedRoute用，因為此頁面都是從nav_item頁面(mode, wordList)"內"導向過來
  static Route route({@required DetailScreenArgs args}) {
    // 可以側滑顯示，所以用MaterialPageRoute()
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      // 若bloc或cubit只限這一頁使用，可在builder屬性值註冊BlocProvider<T>()
      builder: (context) => BlocProvider<AudioSettingCubit>(
        create: (_) => AudioSettingCubit(
          localDataRepository: context.read<LocalDataRepository>(),
          apiRepository: context.read<APIRepository>(),
          // AudioSettingCubit一建立時就去sqlite取目前存的那筆資料來更新state狀態(蓋掉預設狀態)
        )..getLocalAudioSettingState(),
        child: DetailScreen(sentenceBundle: args.sentenceBundle),
      ),
    );
  }

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // ExpandableBottomSheetStaten所需的key，才可呼叫一些方法
  GlobalKey<ExpandableBottomSheetState> _key = GlobalKey();
  // 判斷箭頭圖示用的變數
  bool isArrowDown = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('多益必考金句'),
        centerTitle: true,
      ),
      // ExpandableBottomSheet()物件要放在body屬性值
      body: ExpandableBottomSheet(
        // 要有key
        key: _key,
        // 下拉"到底"會觸發的callback
        onIsContractedCallback: () {
          setState(() => isArrowDown = false);
        },
        // 上拉"到底"會觸發的callback
        onIsExtendedCallback: () => setState(() => isArrowDown = true),
        // 點按header會toggle
        enableToggle: true,
        // background屬性值(必備)是此頁"非上下拉部份"的widget
        background: Column(
          children: [
            // ListView()為Column()的child一定要外包Expanded()
            Expanded(
              child: ListView(
                children: [
                  // 至少要先有一個children widget
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 15.0,
                    ),
                    child: CustomElevatedButton(
                      edgeInset: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 90.0),
                      fontSize: 18.0,
                      text: '測試getUser',
                      onPressed: () async {
                        // User user = User(
                        //     email: 'maxmarco0311@gmail.com',
                        //     valid: false,
                        //     rating: '6');
                        // final User updatedUser = await context
                        //     .read<AudioSettingCubit>()
                        //     .updateUser(user: user);
                        final SentenceBundle sentence = await context
                            .read<AudioSettingCubit>()
                            .getSentenceBundleByVocabularyId(
                              email: 'maxmarco0311@gmail.com',
                              vocabularyId: '5',
                            );
                        // final User updatedUser = await context
                        //     .read<AudioSettingCubit>()
                        //     .getUser(email: 'maxmarco0311@gmail.com');
                        print(sentence.toString());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // header部份的widget(非必要屬性，不會隱藏)(灰色橫條容器 + 箭頭button + divider)
        persistentHeader: Container(
          // 會影響divider左右兩邊與螢幕的距離
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          // 圓角外型
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
                    // 調整箭頭上下
                    padding: const EdgeInsets.only(top: 8.0),
                    // 用isArrowDown判斷要顯示向上或向下的箭頭
                    child: isArrowDown
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 40.0,
                            ),
                            // 向下箭頭點按後會收合到底(會觸發onIsContractedCallback)
                            onPressed: () => _key.currentState.contract(),
                          )
                        // 因為一進入頁面expandable bottom sheet打不開，所以預設用TextButton.icon
                        : TextButton.icon(
                            // 顏色在這換
                            style: TextButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            // 點按後會展開到最大(會觸發onIsExtendedCallback)
                            onPressed: () => _key.currentState.expand(),
                            // Icon(Icons.keyboard_voice_sharp)
                            icon: Icon(MdiIcons.waveform),
                            label: Text('音檔播放介面'),
                          )),
              ),
              SizedBox(
                height: 15.0,
                child: Divider(color: Colors.grey.shade900),
              ),
            ],
          ),
        ),
        // expandableContent是必要屬性：為可收合部份的widget-->player
        // 靠BlocBuilder重繪
        expandableContent: BlocBuilder<AudioSettingCubit, AudioSettingState>(
          // // 這裡的buildWhen沒作用
          // buildWhen: (previous, current) {
          //   return previous.status == Status.initStateLoading &&
          //       current.status == Status.initStateLoaded;
          // },
          builder: (context, state) {
            // 取得cubit
            final cubit = context.read<AudioSettingCubit>();
            // 沒有錯誤就顯示Player
            if (state.status != Status.failure &&
                state.status != Status.initStateLoading &&
                state.status != Status.initial) {
              print(state.status.toString());
              print('player to build!');
              print('要傳進player的url:${_getUrlBySetting(state)}');
              return Player(
                sentenceId: '${widget.sentenceBundle.sentence.sentenceId}',
                url: _getUrlBySetting(state),
                // 要把顯示bottomsheet的callback function(型別為VoidCallback)傳給Player()
                onSetting: _showAudioSetting(context, state),
                // 傳入state與cubit
                state: state,
                cubit: cubit,
                // 傳入player widget用來收合player的函式，用callback方式傳入
                // player屬性型別用Function即可
                contractPlayer: () => _key.currentState.contract(),
              );
            } else if (state.status == Status.failure) {
              return Center(
                child: Text('錯誤'),
              );
            } else {
              print(state.status.toString());
              print('build blank!');
              return SizedBox.shrink();
            }
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
    // 取得cubit
    final cubit = context.read<AudioSettingCubit>();
    // 回傳callback function(VoidCallback型別)
    return () {
      // 內建打開bottom sheet的方法
      showModalBottomSheet(
        enableDrag: true,
        // 鍵盤不擋住bottom sheet的步驟：
        // 1. 設此屬性
        isScrollControlled: true,
        // 點按不能關bottom sheet
        // isDismissible: false,
        // 圓角外型用RoundedRectangleBorder()就好
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // 兩個必備屬性
        context: context,
        // 不需要用builder的context
        builder: (_) => BottomSheetContent(
          context: context,
          state: state,
          cubit: cubit,
        ),
      );
    };
  }
}

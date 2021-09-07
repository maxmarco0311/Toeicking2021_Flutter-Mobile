// import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/custom_packages/packages.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/screens/detail/widgets/widgets.dart';
import 'package:toeicking2021/widgets/widgets.dart';

// 路由參數：SentenceBundle物件
class DetailScreenArgs {
  final SentenceBundle sentenceBundle;
  // 判斷是從哪一頁轉來的
  final bool fromWordList;
  final int sentenceId;
  DetailScreenArgs({
    // sentenceTile傳來才要的
    this.sentenceBundle,
    // 兩頁轉來都要傳的路由參數
    @required this.fromWordList,
    // wordList傳來才要的
    this.sentenceId,
  });
}

class DetailScreen extends StatefulWidget {
  // 將路由參數變成此頁的屬性
  final SentenceBundle sentenceBundle;
  final bool fromWordList;
  final int sentenceId;
  const DetailScreen({
    Key key,
    // sentenceTile傳來才要的
    this.sentenceBundle,
    // 兩頁轉來都要
    @required this.fromWordList,
    // wordList傳來才要的
    this.sentenceId,
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
      // ***若這頁要註冊不只一個Bloc，要使用MultiBlocProvider()***
      // ***一樣可以用chain operator去觸發事件***
      // 用args.fromWordList判斷是哪一頁導過來的
      builder: (context) => args.fromWordList
          // 從wordList來要實體化兩個bloc
          ? MultiBlocProvider(
              providers: [
                BlocProvider<AudioSettingCubit>(
                  create: (_) => AudioSettingCubit(
                    localDataRepository: context.read<LocalDataRepository>(),
                    apiRepository: context.read<APIRepository>(),
                    // AudioSettingCubit一建立時就去sqlite取目前存的那筆資料來更新state狀態(蓋掉預設狀態)
                  )..getLocalAudioSettingState(),
                ),
                // 靠SentenceBundleBloc在這頁生出sentenceBundle
                BlocProvider<SentenceBundleBloc>(
                  create: (_) => SentenceBundleBloc(
                    apiRepository: context.read<APIRepository>(),
                    // SentenceBundleBloc一建立時就用api取該編號的SentenceBundle來更新state狀態(蓋掉預設狀態)
                  )..add(
                      SentenceBundleLoadBySentenceId(
                          // 使用者email可到處取得
                          email: context.read<AuthBloc>().state.user.email,
                          // 使用路由參數
                          sentenceId: args.sentenceId),
                    ),
                ),
              ],
              child: DetailScreen(
                // 建構式不需要sentenceBundle，因為要從bloc裡面取
                fromWordList: args.fromWordList,
                sentenceId: args.sentenceId,
              ),
            )
          // 從mode來只要實體化一個bloc
          : BlocProvider<AudioSettingCubit>(
              create: (_) => AudioSettingCubit(
                localDataRepository: context.read<LocalDataRepository>(),
                apiRepository: context.read<APIRepository>(),
                // AudioSettingCubit一建立時就去sqlite取目前存的那筆資料來更新state狀態(蓋掉預設狀態)
              )..getLocalAudioSettingState(),
              child: DetailScreen(
                // 建構式需要sentenceBundle
                sentenceBundle: args.sentenceBundle,
                fromWordList: args.fromWordList,
              ),
            ),
    );
  }

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  // ExpandableBottomSheetStaten所需的key，才可呼叫一些方法
  GlobalKey<ExpandableBottomSheetState> _expandableKey = GlobalKey();
  // 判斷箭頭圖示用的變數
  bool isArrowDown = false;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print(
        'fromWordList:${widget.fromWordList.toString()}, isArrowDown:${isArrowDown.toString()}');
    // 不同頁轉來的sentenceId(一定要用變數存起來，方便管理)
    int sentenceId = widget.fromWordList
        ? widget.sentenceId
        : widget.sentenceBundle.sentence.sentenceId;
    return Scaffold(
      backgroundColor: Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          '多益必考金句${sentenceId.toString()}',
          style: TextStyle(letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      // ExpandableBottomSheet()物件要放在body屬性值
      // BlocConsumer放在這裡，因為從這開始要用state的資料
      body: BlocConsumer<SentenceBundleBloc, SentenceBundleState>(
        listener: (context, sentenceState) {
          // TODO: implement listener
        },
        builder: (context, sentenceState) {
          // 用switch判斷state.status來決定UI的顯示
          switch (sentenceState.status) {
            case SentenceBundleStateStatus.error:
              return CenteredText(text: '出現無法預期的錯誤！');
            case SentenceBundleStateStatus.loading:
              return const Center(child: CircularProgressIndicator());
            // ***從wordList導來的(使用state.sentenceTile)***
            case SentenceBundleStateStatus.loaded:
              return ExpandableBottomSheet(
                // 要有key
                key: _expandableKey,
                // 下拉"到底"會觸發的callback
                onIsContractedCallback: () =>
                    setState(() => isArrowDown = false),
                // 上拉"到底"會觸發的callback
                onIsExtendedCallback: () => setState(() => isArrowDown = true),
                // 點按header會toggle
                enableToggle: true,
                // background屬性值(必備)是此頁"非上下拉部份"的widget
                // 使用TabBar最外層要包DefaultTabController
                background: Column(
                  children: [
                    // ***1,2要放在NestedScrollView()的外面，不然會一起scroll***
                    // 因為只要TabBarView的部份可以scroll就好
                    //1. 句子與翻譯
                    DetailSentenceContainer(
                      sentenceBundle: sentenceState.sentenceBundle,
                    ),
                    // 2. TabBar(外包一個Container()可以做外型客製化)
                    TabBarContainer(controller: _tabController),
                    // ***要外包Expanded，NestedScrollView才可以放在column裡面***
                    Expanded(
                      child: NestedScrollView(
                        scrollDirection: Axis.vertical,
                        // headerSliverBuilder為必備屬性，callback function參數必須寫成如下
                        // 回傳List<Widget>
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) => [
                          // 必須用SliverToBoxAdapter，才可有無限scroll的效果
                          // Column()外也必須包SliverToBoxAdapter
                          SliverToBoxAdapter(
                            child: Column(
                              children: [],
                            ),
                          )
                        ],
                        // body為NestedScrollView的必備屬性(要scroll的widget放在這，就是TabBarView)
                        // 3. TabBarView
                        body: DetailTabBarView(
                            controller: _tabController,
                            sentenceBundle: sentenceState.sentenceBundle),
                      ),
                    ),
                  ],
                ),
                // header部份的widget(非必要屬性，不會隱藏)(灰色橫條容器 + 箭頭button + divider)
                persistentHeader: PlayerHeader(
                    isArrowDown: isArrowDown, expandableKey: _expandableKey),
                // expandableContent是必要屬性：為可收合部份的widget-->player(靠BlocBuilder重繪)
                expandableContent:
                    BlocBuilder<AudioSettingCubit, AudioSettingState>(
                  builder: (context, audioState) {
                    // 取得cubit
                    final cubit = context.read<AudioSettingCubit>();
                    // 沒有錯誤就顯示Player
                    if (audioState.status != Status.failure &&
                        audioState.status != Status.initStateLoading &&
                        audioState.status != Status.initial) {
                      print(audioState.status.toString());
                      print('player to build!');
                      print(
                          '要傳進player的url:${_getUrlBySetting(audioState, sentenceState)}');
                      return Player(
                        sentenceId: '$sentenceId',
                        url: _getUrlBySetting(audioState, sentenceState),
                        // 要把顯示bottomsheet的callback function(型別為VoidCallback)傳給Player()
                        onSetting:
                            _showAudioSetting(context, cubit, audioState),
                        // 傳入state與cubit
                        state: audioState,
                        cubit: cubit,
                        // 傳入player widget用來收合player的函式，用callback方式傳入
                        // player屬性型別用Function即可
                        contractPlayer: () =>
                            _expandableKey.currentState.contract(),
                      );
                    } else if (audioState.status == Status.failure) {
                      return Center(
                        child: Text('錯誤'),
                      );
                    } else {
                      print(audioState.status.toString());
                      print('build blank!');
                      return SizedBox.shrink();
                    }
                  },
                ),
              );
            // ***從sentenceTile導來的設為default(使用widget.sentenceTile)***
            default:
              return ExpandableBottomSheet(
                // 要有key
                key: _expandableKey,
                // 下拉"到底"會觸發的callback
                onIsContractedCallback: () =>
                    setState(() => isArrowDown = false),
                // 上拉"到底"會觸發的callback
                onIsExtendedCallback: () => setState(() => isArrowDown = true),
                // 點按header會toggle
                enableToggle: true,
                // background屬性值(必備)是此頁"非上下拉部份"的widget
                // 使用TabBar最外層要包DefaultTabController
                background: Column(
                  children: [
                    // 1,2要放在NestedScrollView()的外面，不然會一起scroll
                    // 因為只要TabBarView的部份可以scroll就好
                    //1. 句子與翻譯
                    DetailSentenceContainer(
                      sentenceBundle: widget.sentenceBundle,
                    ),
                    // 2. TabBar(外包一個Container()可以做外型客製化)
                    TabBarContainer(controller: _tabController),
                    // 要外包Expanded，NestedScrollView才可以放在column裡面
                    Expanded(
                      child: NestedScrollView(
                        scrollDirection: Axis.vertical,
                        // headerSliverBuilder為必備屬性，callback function參數必須寫成如下
                        // 回傳List<Widget>
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) => [
                          // 必須用SliverToBoxAdapter，才可有無限scroll的效果
                          // Column()外也必須包SliverToBoxAdapter
                          SliverToBoxAdapter(
                            child: Column(
                              children: [],
                            ),
                          )
                        ],
                        // body為NestedScrollView的必備屬性(要scroll的widget放在這，就是TabBarView)
                        // 3. TabBarView
                        body: DetailTabBarView(
                            controller: _tabController,
                            sentenceBundle: widget.sentenceBundle),
                      ),
                    ),
                  ],
                ),
                // header部份的widget(非必要屬性，不會隱藏)(灰色橫條容器 + 箭頭button + divider)
                persistentHeader: PlayerHeader(
                    isArrowDown: isArrowDown, expandableKey: _expandableKey),
                // expandableContent是必要屬性：為可收合部份的widget-->player(靠BlocBuilder重繪)
                expandableContent:
                    BlocBuilder<AudioSettingCubit, AudioSettingState>(
                  builder: (context, audioState) {
                    // 取得cubit
                    final cubit = context.read<AudioSettingCubit>();
                    // 沒有錯誤就顯示Player
                    if (audioState.status != Status.failure &&
                        audioState.status != Status.initStateLoading &&
                        audioState.status != Status.initial) {
                      // print(audioState.status.toString());
                      // print('player to build!');
                      // print(
                      //     '要傳進player的url:${_getUrlBySetting(audioState, sentenceState)}');
                      return Player(
                        sentenceId: '$sentenceId',
                        url: _getUrlBySetting(
                          audioState,
                          sentenceState,
                        ),
                        // 要把顯示bottomsheet的callback function(型別為VoidCallback)傳給Player()
                        onSetting:
                            _showAudioSetting(context, cubit, audioState),
                        // 傳入state與cubit
                        state: audioState,
                        cubit: cubit,
                        // 傳入player widget用來收合player的函式，用callback方式傳入
                        // player屬性型別用Function即可
                        contractPlayer: () =>
                            _expandableKey.currentState.contract(),
                      );
                    } else if (audioState.status == Status.failure) {
                      return Center(
                        child: Text('錯誤'),
                      );
                    } else {
                      print(audioState.status.toString());
                      print('build blank!');
                      return SizedBox.shrink();
                    }
                  },
                ),
              );
          }
        },
      ),
    );
  }

  // 獲得url字串
  String _getUrlBySetting(
    AudioSettingState audioState,
    SentenceBundleState sentenceBundleState,
  ) {
    String urlDicKey = audioState.accent + audioState.gender;
    String url = '';
    switch (audioState.rate) {
      case '0.75':
        // 不同頁導來的，資料來源會不一樣
        url = widget.fromWordList
            ? sentenceBundleState.sentenceBundle.slowAudioUrls[urlDicKey]
            : widget.sentenceBundle.slowAudioUrls[urlDicKey];
        break;
      case '1.0':
        url = widget.fromWordList
            ? sentenceBundleState.sentenceBundle.normalAudioUrls[urlDicKey]
            : widget.sentenceBundle.normalAudioUrls[urlDicKey];
        break;
      case '1.25':
        url = widget.fromWordList
            ? sentenceBundleState.sentenceBundle.fastAudioUrls[urlDicKey]
            : widget.sentenceBundle.fastAudioUrls[urlDicKey];
        break;
      default:
        url = '';
    }
    return url;
  }

  // 打開ModalBottomSheet的方法
  VoidCallback _showAudioSetting(
      BuildContext context, AudioSettingCubit cubit, AudioSettingState state) {
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
        shape: kBottomSheetTopRoundedCorner,
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

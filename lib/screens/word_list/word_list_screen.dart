import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/screens/word_list/widgets/widgets.dart';

import 'bloc/wordlist_bloc.dart';

class WordListScreen extends StatefulWidget {
  static const String routeName = '/wordList';
  const WordListScreen({Key key}) : super(key: key);

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  // 因為要下拉進行分頁，所以需要ScrollController物件
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // 要在initState()裡初始化ScrollController()，並設事件監聽器
    // 只要一滑動，就會觸發
    _scrollController = ScrollController()
      ..addListener(
        () {
          // _scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange
          // 上面這段條件式代表***滑動到頁面最下方時還繼續要向下滑動***
          // 再加上context.read<WordlistBloc>().state.status != WordlistStateStatus.paginating
          // 再加上已經撈完全部資料：context.read<WordlistBloc>().state.isLoadedOut == false
          // 確認現在沒有正在撈分頁資料(以免重複撈分頁資料)
          print(
              'total pages:${context.read<WordlistBloc>().state.totalPages.toString()}, current page:${context.read<WordlistBloc>().state.currentPage.toString()}');
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              context.read<WordlistBloc>().state.status !=
                  WordlistStateStatus.paginating &&
              // state中的currentPage最多只會是state中的totalPages加1
              // 加1的原因是在"已經查到最後一頁"後"最後一次"進入WordlistLoad事件中
              // 將status改為loadedOut，以便可顯示字彙已載入完成(只顯示一次，因為<= ... +1才可進入事件)
              // 而不會同時顯示載入更多字彙中
              context.read<WordlistBloc>().state.currentPage <=
                  (context.read<WordlistBloc>().state.totalPages) + 1) {
            // 撈分頁資料
            context.read<WordlistBloc>().add(
                  WordlistLoad(
                      pageSize: '7',
                      currentPage:
                          (context.read<WordlistBloc>().state.currentPage + 1)
                              .toString(),
                      email: context.read<AuthBloc>().state.user.email),
                );
          }
        },
      );
  }

  @override
  void dispose() {
    // 記得要dispose()
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('字彙列表'),
        centerTitle: true,
      ),
      body: BlocConsumer<WordlistBloc, WordlistState>(
        listener: (context, state) {
          if (state.status == WordlistStateStatus.paginating) {
            // 若目前snackbar還沒結束就出現下一個snackbar，呼叫此方法結束目前的snackbar
            // 要在呼叫snackbar之前呼叫這個方法
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // 顯示SnackBar()
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 1),
                content: Text('載入更多字彙中...'),
              ),
            );
          }
          if (state.status == WordlistStateStatus.loadedOut) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                duration: const Duration(seconds: 2),
                content: Text('字彙載入完畢！'),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            // 載入中
            case WordlistStateStatus.loading:
              return CircularProgressIndicator();
              break;
            // 預設顯示資料
            default:
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 20.0,
                ),
                child: ListView.builder(
                  // 要把_scrollController傳入controller屬性
                  controller: _scrollController,
                  itemCount: state.currentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Vocabulary vocabulary = state.currentList[index];
                    return VocabularyTile(vocabulary: vocabulary);
                  },
                ),
              );
          }
        },
      ),
    );
  }
}

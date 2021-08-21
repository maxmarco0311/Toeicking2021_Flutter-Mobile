import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/models/models.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/screens/detail/widgets/widgets.dart';

// TabBar View
class DetailTabBarView extends StatelessWidget {
  final SentenceBundle sentenceBundle;
  const DetailTabBarView({
    Key key,
    @required this.sentenceBundle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ***要先設一個BlocProvider，child widget再設BlocBuilder才有效***
    // 在這使用一個專門管理user狀態的UserBloc，建立bloc時去獲得全部user的資料
    return BlocProvider(
      create: (context) => UserBloc(
        apiRepository: context.read<APIRepository>(),
      )..add(
          // ***可在任何地方用context.read<AuthBloc>().state.user.email取得email***
          UserFetch(email: context.read<AuthBloc>().state.user.email),
        ),
      child: TabBarView(
        children: [
          // 1. 必考字彙
          // ListView的padding，每個tab都要一樣
          // 也跟上面句子容器的左右padding(25.0)一樣，看起來會比較整齊
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            child: ListView.builder(
              itemCount: sentenceBundle.vocabularies.length,
              itemBuilder: (context, index) {
                Vocabulary vocabulary = sentenceBundle.vocabularies[index];
                // ***這裡設BlocBuilder，VocTile()裡有更新到UserState(按愛心)會重繪!***
                return BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    print(
                        'email: ${context.read<AuthBloc>().state.user.email}');
                    print('wordList:${state.wordList.toString()}');
                    bool isInWordList = false;
                    // 要檢查字彙清單是否為null(沒有加入字彙清單的就是null)，否則會報錯
                    if (state.wordList != null) {
                      // 判斷此字彙是否有加入字彙列表(判斷愛心用)，並將布林變數傳入VocTile()
                      isInWordList =
                          state.wordList.contains(vocabulary.vocabularyId);
                    }
                    return VocTile(
                      vocabulary: vocabulary,
                      email: state.email,
                      // VocTile()裡的context不能呼叫read()，所以要傳入bloc
                      bloc: context.read<UserBloc>(),
                      isInWordList: isInWordList,
                    );
                  },
                );
              },
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text("字彙解析"),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text("文法解析"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

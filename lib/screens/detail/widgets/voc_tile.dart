import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toeicking2021/blocs/blocs.dart';
import 'package:toeicking2021/models/models.dart';

class VocTile extends StatelessWidget {
  final Vocabulary vocabulary;
  final UserBloc bloc;
  final String email;
  final bool isInWordList;

  const VocTile({
    Key key,
    @required this.vocabulary,
    @required this.bloc,
    @required this.email,
    @required this.isInWordList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            // 文字和愛心都是對齊上方
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文字部份
              // 要用container包住並給一個固定寬度才不會因文字多寡而有不整齊的排版(尤其是愛心部份)
              // 此處的頁面寬度需扣掉listview的左右padding(共50.0)，之後就可以完全用百分比計算分配寬度
              Container(
                width: ((MediaQuery.of(context).size.width) - 50.0) * 0.9,
                child: Row(
                  // 萬一文字多行時是對齊上方的
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 字彙
                    Text(
                      vocabulary.voc,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 8.0),
                    // 詞性
                    Text(
                      '(${vocabulary.category}.)',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 8.0),
                    // 中文(Text()外包Expanded()可多行顯示文字)
                    Expanded(
                      child: Text(
                        vocabulary.chinese,
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Noto'),
                      ),
                    ),
                  ],
                ),
              ),
              // 愛心部份
              Container(
                width: ((MediaQuery.of(context).size.width) - 50) * 0.1,
                // 用IconButton()排版怪怪的，所以用GestureDetector()
                child: GestureDetector(
                  onTap: () {
                    // 如果沒有加入字彙列表
                    if (!isInWordList) {
                      // 按下去加入字彙列表
                      bloc.add(
                        AddWordList(
                            email: email,
                            vocabularyId: vocabulary.vocabularyId),
                      );
                    }
                  },
                  child: isInWordList
                      ? Icon(
                          MdiIcons.heart,
                          color: Colors.red[400],
                        )
                      : Icon(
                          MdiIcons.heartOutline,
                          color: Colors.grey,
                        ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VocTile extends StatelessWidget {
  final int sentenceId;
  final int vocabularyId;
  final String voc;
  final String category;
  final String chinese;
  const VocTile({
    Key key,
    @required this.sentenceId,
    @required this.vocabularyId,
    @required this.voc,
    @required this.category,
    @required this.chinese,
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
                      voc,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 8.0),
                    // 詞性
                    Text(
                      '($category.)',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 8.0),
                    // 中文(Text()外包Expanded()可多行顯示文字)
                    Expanded(
                      child: Text(
                        '$chinese',
                        style: TextStyle(fontSize: 16.0),
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
                    print('tap!');
                  },
                  child: Icon(
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

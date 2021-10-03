import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toeicking2021/utilities/control_list.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({Key key}) : super(key: key);

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
        child: Column(
          children: [
            Text(
              '大題分類',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            GFMultiSelect(
              // 這裡要改成用partCategories，而partCategories也要改成List<dynamic>型別
              // 選到的值是index陣列，還要再處理一下
              items: partCategories,
              onSelect: (value) {
                // 傳入的是所選到元素的index值集合
                print('selected $value ');
              },
              dropdownTitleTileText: '請選擇',
              dropdownTitleTileMargin:
                  EdgeInsets.only(top: 22, left: 18, right: 18, bottom: 5),
              dropdownTitleTilePadding: EdgeInsets.all(10),
              dropdownUnderlineBorder:
                  const BorderSide(color: Colors.transparent, width: 2),
              dropdownTitleTileBorder:
                  Border.all(color: Colors.grey[200], width: 1),
              dropdownTitleTileBorderRadius: BorderRadius.circular(5),
              expandedIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black54,
              ),
              collapsedIcon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black54,
              ),
              submitButton: Text('OK'),
              cancelButton: Text('Cancel'),
              dropdownTitleTileTextStyle:
                  const TextStyle(fontSize: 14, color: Colors.black54),
              padding: const EdgeInsets.all(6),
              margin: const EdgeInsets.all(6),
              type: GFCheckboxType.basic,
              activeBgColor: GFColors.SUCCESS,
              activeBorderColor: GFColors.SUCCESS,
              inactiveBorderColor: Colors.grey[200],
            ),
            CustomElevatedButton(
              fontSize: 18.0,
              edgeInset: EdgeInsets.symmetric(horizontal: 0.0, vertical: 11.0),
              text: '完成',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

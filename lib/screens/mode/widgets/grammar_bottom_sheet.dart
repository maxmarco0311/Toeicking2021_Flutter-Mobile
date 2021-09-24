import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toeicking2021/utilities/control_list.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class GrammarBottomSheet extends StatefulWidget {
  const GrammarBottomSheet({Key key}) : super(key: key);

  @override
  _GrammarBottomSheetState createState() => _GrammarBottomSheetState();
}

class _GrammarBottomSheetState extends State<GrammarBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
        child: Column(
          children: [
            Text(
              '文法分類',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            GFMultiSelect(
              items: grammarCategories,
              onSelect: (value) {
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

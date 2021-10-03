import 'package:flutter/material.dart';
import 'package:toeicking2021/screens/mode/widgets/widgets.dart';
import 'package:toeicking2021/utilities/utilities.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class GrammarBottomSheet extends StatefulWidget {
  const GrammarBottomSheet({Key key}) : super(key: key);

  @override
  _GrammarBottomSheetState createState() => _GrammarBottomSheetState();
}

class _GrammarBottomSheetState extends State<GrammarBottomSheet> {
  // 母下拉的value
  String topSelectedValue;
  // 子下拉的value
  String subSelectedValue;
  // 控制子下拉的顯示
  bool showSubDropdown = false;
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
            // 母下拉
            DropdownList(
              // initialTopValue: "1",
              dropdownList: topDropdown,
              value: topSelectedValue,
              onChanged: (newValue) {
                setState(() {
                  //子下拉有選取後(這時子下拉的value(subSelectedValue)已經有值)，又要再選母下拉生出另一個子下拉
                  //但依內建Widget設計，新的子下拉items中一定要有一個item的value值必須跟原來選取的value值一樣
                  //否則會報錯，解決之道***是在母下拉改變時，將子下拉的value值變null***
                  subSelectedValue = null;
                  // 將選中的值給狀態變數
                  topSelectedValue = newValue;
                  showSubDropdown = true;
                });
              },
            ),
            // 要用Bloc狀態變數(因為可能一打開就要顯示"子下拉")控制顯示
            showSubDropdown
                ? Column(
                    children: [
                      DropdownList(
                        value: subSelectedValue,
                        // 利用母下拉的value(topSelectedValue)決定子下拉的Map
                        dropdownList: grammarCategoryMap[topSelectedValue],
                        onChanged: (newValue) {
                          setState(() => subSelectedValue = newValue);
                        },
                      ),
                      SizedBox(height: 20.0),
                    ],
                  )
                : SizedBox.shrink(),
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

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toeicking2021/utilities/utilities.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class ScenarioBottomSheet extends StatefulWidget {
  const ScenarioBottomSheet({Key key}) : super(key: key);

  @override
  _ScenarioBottomSheetState createState() => _ScenarioBottomSheetState();
}

class _ScenarioBottomSheetState extends State<ScenarioBottomSheet> {
  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
        child: Column(
          children: [
            Text(
              '情境分類',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            // 這裡的Container只是文字框容器，長寬可以直接套用
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              // 這裡才是下拉選單容器
              child: DropdownButtonHideUnderline(
                child: GFDropdown(
                  padding: const EdgeInsets.all(15),
                  borderRadius: BorderRadius.circular(5),
                  border: const BorderSide(color: Colors.black12, width: 1),
                  dropdownButtonColor: Colors.grey[300],
                  // 選中後的value
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                    print(dropdownValue);
                  },
                  // 從自己的map繫結成List<DropdownMenuItem<String>
                  items: contextCategories
                      .map(
                        (key, value) => MapEntry(
                          key,
                          DropdownMenuItem(
                            value: value,
                            // child型別是widget，所以可以客製化，比較不會那麼陽春
                            child: Text(key),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
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

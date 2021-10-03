import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toeicking2021/screens/mode/widgets/dropdown_list.dart';
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
            DropdownList(
              value: dropdownValue,
              // initialValue: '',
              dropdownList: contextCategories,
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
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

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DropdownList extends StatefulWidget {
  final String value;
  final Map<String, dynamic> dropdownList;
  final Function onChanged;
  const DropdownList({
    Key key,
    @required this.value,
    @required this.dropdownList,
    @required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    // 文字框容器
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      // 這裡才是下拉選單部份的容器
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(5),
          border: const BorderSide(color: Colors.black12, width: 1),
          dropdownButtonColor: Colors.grey[300],
          // 選中的value，可拿來設預設值
          value: widget.value,
          hint: Text('請選擇'),
          onChanged: widget.onChanged,
          // 從自己的Map<String,String>繫結成List<DropdownMenuItem<String>>
          items: widget.dropdownList
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
    );
  }
}

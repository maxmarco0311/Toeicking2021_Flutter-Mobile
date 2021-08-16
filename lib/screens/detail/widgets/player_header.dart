import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toeicking2021/config/ui_const.dart';
import 'package:toeicking2021/custom_packages/expandable_bottom_sheet.dart';

// 播放器的header
class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    Key key,
    @required this.isArrowDown,
    @required GlobalKey<ExpandableBottomSheetState> expandableKey,
  })  : _expandableKey = expandableKey,
        super(key: key);

  final bool isArrowDown;
  final GlobalKey<ExpandableBottomSheetState> _expandableKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 會影響divider左右兩邊與螢幕的距離
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      // 圓角外型
      decoration: BoxDecoration(
        // 如果要設decoration屬性，就得把color屬性放進BoxDecoration()裡，否則會報錯
        color: Colors.grey.shade200,
        borderRadius: kPlayerTopRoundedCorner,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 使用SizedBox()包住chidren widget，並設定高度後是去掉原有padding的方式
          SizedBox(
            height: 45.0,
            child: Padding(
                // 調整箭頭上下
                padding: const EdgeInsets.only(top: 8.0),
                // 用isArrowDown判斷要顯示向上或向下的箭頭
                child: isArrowDown
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 40.0,
                        ),
                        // 向下箭頭點按後會收合到底(會觸發onIsContractedCallback)
                        onPressed: () => _expandableKey.currentState.contract(),
                      )
                    // 因為一進入頁面expandable bottom sheet打不開，所以預設用TextButton.icon
                    : TextButton.icon(
                        // 顏色在這換
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        // 點按後會展開到最大(會觸發onIsExtendedCallback)
                        onPressed: () => _expandableKey.currentState.expand(),
                        // Icon(Icons.keyboard_voice_sharp)
                        icon: Icon(MdiIcons.waveform),
                        label: Text('音檔播放'),
                      )),
          ),
          SizedBox(
            height: 15.0,
            child: Divider(color: Colors.grey.shade900),
          ),
        ],
      ),
    );
  }
}

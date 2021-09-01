import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toeicking2021/config/ui_const.dart';
import 'package:toeicking2021/cubits/cubits.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class ShowAudioSetting {
  static VoidCallback openBottomSheet(
    BuildContext context,
    AudioSettingCubit cubit,
    AudioSettingState state,
  ) {
    // 取得cubit
    // final cubit = context.read<AudioSettingCubit>();
    // 回傳callback function(VoidCallback型別)
    return () {
      // 內建打開bottom sheet的方法
      showModalBottomSheet(
        enableDrag: true,
        // 鍵盤不擋住bottom sheet的步驟：
        // 1. 設此屬性
        isScrollControlled: true,
        // 點按不能關bottom sheet
        // isDismissible: false,
        // 圓角外型用RoundedRectangleBorder()就好
        shape: kBottomSheetTopRoundedCorner,
        // 兩個必備屬性
        context: context,
        // 不需要用builder的context
        builder: (_) => BottomSheetContent(
          context: context,
          state: state,
          cubit: cubit,
        ),
      );
    };
  }
}

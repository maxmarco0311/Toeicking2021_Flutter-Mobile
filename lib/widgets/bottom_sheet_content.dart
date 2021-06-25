import 'package:flutter/material.dart';

import 'package:toeicking2021/cubits/audio_setting/audio_setting_cubit.dart';

class BottomSheetContent extends StatelessWidget {
  final BuildContext context;
  final AudioSettingCubit cubit;
  final AudioSettingState state;
  const BottomSheetContent({
    Key key,
    @required this.context,
    @required this.cubit,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

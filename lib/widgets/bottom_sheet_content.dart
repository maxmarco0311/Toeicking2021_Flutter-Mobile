import 'package:flutter/material.dart';

import 'package:toeicking2021/cubits/audio_setting/audio_setting_cubit.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class BottomSheetContent extends StatefulWidget {
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
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String genderSelectedValue;
  String rateSelectedValue;
  String accentSelectedValue;
  TextEditingController _controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isValidated = false;
  @override
  void initState() {
    genderSelectedValue = widget.state.gender;
    rateSelectedValue = widget.state.rate;
    accentSelectedValue = widget.state.accent;
    // 這樣文字框就有預設值
    _controller =
        TextEditingController(text: (widget.state.repeatedTimes).toString());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 點按Container()鍵盤就會離開
      onTap: () {
        // // 每個欄位恢復初始值，防止使用者沒通過驗證就把bottom sheet關掉，會有排版問題
        // _formKey.currentState.reset();
        // FocusScope.of(context).unfocus();
        // 或限制驗證沒通過就不能鍵盤離開
        if (isValidated == false) {
          FocusScope.of(context).unfocus();
        }
      },
      // 鍵盤不擋住bottom sheet的步驟：
      // 2. 最外層包SingleChildScrollView()
      child: SingleChildScrollView(
        child: Container(
          // 3. Container()的padding要設成如下
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // 4. 內容物的padding要設在Column()
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  height: 50.0,
                  child: Row(
                    children: [
                      Text(
                        '腔調：',
                        style: kBottomSheetTextStyle,
                      ),
                      Row(
                        children: [
                          _buildAccentRadioButtonSet(
                            accentValue: 'US',
                            imageUrl: 'assets/images/test.jpg',
                          ),
                          SizedBox(width: 5.0),
                          _buildAccentRadioButtonSet(
                            accentValue: 'GB',
                            imageUrl: 'assets/images/test.jpg',
                          ),
                          SizedBox(width: 5.0),
                          _buildAccentRadioButtonSet(
                            accentValue: 'AU',
                            imageUrl: 'assets/images/test.jpg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kBottomSheetSizeBoxHeight),
                Container(
                  padding: EdgeInsets.zero,
                  height: 50.0,
                  child: Row(
                    children: [
                      Text(
                        '聲道：',
                        style: kBottomSheetTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGenderRadioButtonSet(
                              genderValue: 'M', label: '男聲'),
                          SizedBox(width: 5.0),
                          _buildGenderRadioButtonSet(
                              genderValue: 'F', label: '女聲'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kBottomSheetSizeBoxHeight),
                Container(
                  padding: EdgeInsets.zero,
                  height: 50.0,
                  child: Row(
                    children: [
                      Text(
                        '語速：',
                        style: kBottomSheetTextStyle,
                      ),
                      // ListView若是child widgte外面必包Expanded()
                      // 其parent widget外也要包Container()
                      // 且指定高度(給橫向ListView)、指定寬度(給縱向ListView)
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildRateRadioButtonSet(
                                rateValue: '1.25', label: '快速(x1.25)'),
                            SizedBox(width: 5.0),
                            _buildRateRadioButtonSet(
                                rateValue: '1.0', label: '正常(x1.0)'),
                            SizedBox(width: 5.0),
                            _buildRateRadioButtonSet(
                                rateValue: '0.75', label: '慢速(x0.75)'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: kBottomSheetSizeBoxHeight),
                Container(
                  padding: EdgeInsets.zero,
                  // InputDecoration()要設contentPadding，這裡就不能設高度
                  // height: 50.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 為了要在出現錯誤訊息時可置中對齊
                      // 只好在文字外包一個container
                      // 出現錯誤訊息時(isValidated=true)就出現下方的padding，也往上推
                      Container(
                        padding: isValidated
                            ? EdgeInsets.only(bottom: 28.0)
                            : EdgeInsets.zero,
                        child: Text(
                          '重複播放次數：',
                          style: kBottomSheetTextStyle,
                        ),
                      ),
                      // 文字框旁邊有內容，文字框要包Expanded()
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            // _key(FormKey)可以直接放在TextFormField單獨使用
                            // 使用Form()的好處是一次可以處理多個TextFormField
                            // controller屬性不可以和intitalValue同時用
                            controller: _controller,
                            // 數字鍵盤
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // 設contentPadding，錯誤訊息出現時不會把內容上推
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              // 下列兩個屬性設定文字框背景顏色
                              fillColor: Colors.grey[200],
                              filled: true,
                              // 去掉框線
                              border: InputBorder.none,
                              hintText: '請輸入次數',
                              // 尾巴x按鈕
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  // 清空文字框
                                  _controller.clear();
                                },
                              ),
                            ),
                            validator: (input) {
                              // 轉型成int做檢查
                              final isDigitsOnly = int.tryParse(input);
                              // 數字出現100要報錯誤訊息
                              if (isDigitsOnly == null || isDigitsOnly > 100) {
                                setState(() => isValidated = true);
                                isValidated = true;
                                return '必需輸入數字0~100';
                              } else {
                                setState(() => isValidated = false);
                                return null;
                              }
                            },
                            onChanged: (value) {
                              // 如果通過驗證
                              if (_formKey.currentState.validate()) {
                                // 改變狀態
                                widget.cubit.updateRepeatedTimes(
                                    repeatedTimes: int.tryParse(value));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  child: CustomElevatedButton(
                    text: '設定完成',
                    onPressed: () {
                      // // 每個欄位恢復初始值，防止使用者沒通過驗證就把bottom sheet關掉，會有排版問題
                      // _formKey.currentState.reset();
                      // Navigator.of(context).pop();
                      // 或限制驗證沒通過就不能關閉bottom sheet
                      if (isValidated == false) {
                        Navigator.of(context).pop();
                      }
                    },
                    edgeInset: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 120.0),
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderRadioButtonSet({String genderValue, String label}) {
    return Row(
      children: [
        Transform.scale(
          scale: kRadioButtonScale,
          child: Radio<String>(
            value: genderValue,
            groupValue: genderSelectedValue,
            // 選中時會觸發，傳入value屬性值
            onChanged: (value) {
              // 將value屬性值賦值給groupValue屬性值，即會呈現選中
              setState(() => genderSelectedValue = value);
              widget.cubit.updateGender(gender: value);
            },
          ),
        ),
        Text(
          label,
          style: kBottomSheetTextStyle,
        )
      ],
    );
  }

  Widget _buildRateRadioButtonSet({String rateValue, String label}) {
    return Row(
      children: [
        Transform.scale(
          scale: kRadioButtonScale,
          child: Radio<String>(
            value: rateValue,
            groupValue: rateSelectedValue,
            onChanged: (value) {
              setState(() => rateSelectedValue = value);
              widget.cubit.updateRate(rate: value);
            },
          ),
        ),
        Text(
          label,
          style: kBottomSheetTextStyle,
        )
      ],
    );
  }

  Widget _buildAccentRadioButtonSet({String accentValue, String imageUrl}) {
    return Row(
      children: [
        Transform.scale(
          scale: kRadioButtonScale,
          child: Radio<String>(
            value: accentValue,
            groupValue: accentSelectedValue,
            onChanged: (value) {
              setState(() => accentSelectedValue = value);
              widget.cubit.updateAccent(accent: value);
            },
          ),
        ),
        Image(
          height: 35.0,
          width: 50.0,
          image: AssetImage(imageUrl),
        ),
      ],
    );
  }
}

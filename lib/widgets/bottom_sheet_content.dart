import 'dart:async';

import 'package:flutter/material.dart';

import 'package:toeicking2021/cubits/audio_setting/audio_setting_cubit.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class BottomSheetContent extends StatefulWidget {
  final BuildContext context;
  final AudioSettingCubit cubit;
  // 在DetailScreen初始時就初始AudioSettingCubit，然後呼叫getLocalAudioSettingState()
  // 來獲得state資料再傳入這裡，有點太上層了，可以再改進
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
  // 要更新State用的變數(共四個)
  String genderSelectedValue;
  String rateSelectedValue;
  String accentSelectedValue;
  // 用來更新state裡面的statusStreamController，因此型別要一樣
  StreamController<Status> _statusStreamController;
  // 替文字框設預設值和清除文字框要用
  TextEditingController _controller;
  // 使用validate()方法
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 專門用來調整validation message出現後，文字框旁邊padding用的變數
  bool isValidated = false;

  @override
  void initState() {
    // 先從傳入的state中獲得目前狀態的值，給radio button預設值用
    genderSelectedValue = widget.state.gender;
    rateSelectedValue = widget.state.rate;
    accentSelectedValue = widget.state.accent;
    // 獲得state中現有的statusStreamController，否則此頁的_statusStreamController會是null
    _statusStreamController = widget.state.statusStreamController;
    // (從state獲得)文字框獲得預設值的方法(不能跟initialValue同時用)
    _controller =
        TextEditingController(text: (widget.state.repeatedTimes).toString());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    //  呼叫close，程式邏輯會報錯(不是編譯報錯)
    // _statusStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 點按Container()鍵盤就會離開
      onTap: () {
        // 每個欄位恢復初始值，防止使用者沒通過驗證就把bottom sheet關掉，會有排版問題
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
                            imageUrl: 'assets/images/america.jpg',
                          ),
                          SizedBox(width: 5.0),
                          _buildAccentRadioButtonSet(
                            accentValue: 'GB',
                            imageUrl: 'assets/images/britain.png',
                          ),
                          SizedBox(width: 5.0),
                          _buildAccentRadioButtonSet(
                            accentValue: 'AU',
                            imageUrl: 'assets/images/australia.png',
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
                      // 且指定height(給橫向ListView)、指定寬度width(給縱向ListView)
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
                      // 為了要在出現錯誤訊息時文字和文字框都可置中對齊
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
                      // 文字框左邊若有內容，文字框要佔據剩餘寬度時要包Expanded()
                      // 若文字框要有固定寬度，只需要在TextFormField()外包一個Container()
                      Form(
                        key: _formKey,
                        child: Container(
                          // 文字框的固定寬度
                          width: 110.0,
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
                              // 不是數字以及數字大於100要報錯誤訊息
                              if (isDigitsOnly == null || isDigitsOnly > 100) {
                                setState(() => isValidated = true);
                                // isValidated = true;
                                // 錯誤訊息
                                return '輸入數字0~100';
                              } else {
                                setState(() => isValidated = false);
                                // 沒有錯誤訊息
                                return null;
                              }
                            },
                            // onSaved的傳入參數為文字框的final value
                            // callback裡通常是將final value裝進資料容器
                            // 呼叫_formKey.currentState.save()後便會觸發onSaved的callback
                            // 接下來再把裝好的資料作進一步的處理(如狀態管理)
                            // 以上兩個步驟應該包在自訂的_submit()方法裡
                            // 然後再當一個按鈕的onPressed callback
                            onSaved: (finalValue) {},
                            onChanged: (value) {
                              // 如果通過驗證
                              if (_formKey.currentState.validate()) {
                                // 改變狀態
                                widget.cubit.updateRepeatedTimes(
                                  repeatedTimes: int.tryParse(value),
                                  status: Status.repeatedTimesUpdate,
                                  // ***將此頁的_statusStreamController傳進state裡更新***
                                  // ***cubit裡不同的方法會把上面的status值sink.add進入stream中***
                                  // ***把這頁的_statusStreamController傳入方法，確保stream會觸發上面status值的事件***
                                  statusStreamController:
                                      _statusStreamController,
                                );
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
                      // 每個欄位恢復初始值，防止使用者沒通過驗證就把bottom sheet關掉，會有排版問題
                      // _formKey.currentState.reset();
                      // Navigator.of(context).pop();
                      // 限制驗證沒通過就不能關閉bottom sheet
                      if (isValidated == false) {
                        // 呼叫更新重複播放次數的cubit方法
                        widget.cubit.updateRepeatedTimes(
                          repeatedTimes: int.tryParse(_controller.text),
                          status: Status.repeatedTimesUpdate,
                          statusStreamController: _statusStreamController,
                        );
                        // 關閉bottom sheet
                        Navigator.of(context).pop();
                      }
                    },
                    edgeInset: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 120.0),
                    fontSize: 18.0,
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
        // 放大radio button
        Transform.scale(
          scale: kRadioButtonScale,
          child: Radio<String>(
            // value屬性值是選中這個radio時會取到的值，從參數中傳入
            value: genderValue,
            // groupValue屬性值和value屬性值一樣時，代表這個radio選中了
            // group radio中每個groupValue都要一樣，才能單選，所以屬性值要用變數
            // 也是因為要從cubit裡獲得預設值
            groupValue: genderSelectedValue,
            // 選中時會觸發，傳入參數為value屬性值(genderValue)
            onChanged: (value) {
              // 將value屬性值賦值給groupValue屬性值，即會呈現選中
              setState(() => genderSelectedValue = value);
              // 更改state狀態
              widget.cubit.updateGender(
                  gender: value,
                  status: Status.genderUpdate,
                  statusStreamController: _statusStreamController);
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
              widget.cubit.updateRate(
                  rate: value,
                  status: Status.rateUpdate,
                  statusStreamController: _statusStreamController);
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
              widget.cubit.updateAccent(
                  accent: value,
                  status: Status.accentUpdate,
                  statusStreamController: _statusStreamController);
            },
          ),
        ),
        Image(
          height: 35.0,
          width: 50.0,
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

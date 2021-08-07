import 'package:flutter/material.dart';
import 'package:toeicking2021/repositories/repositories.dart';
import 'package:toeicking2021/screens/screens.dart';
import 'package:toeicking2021/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);
  static const String routeName = '/forgotPassword';
  static Route route() {
    // MaterialPageRoute()有兩個常見的屬性：
    // 1. settings-->屬性值型別為RouteSettings()，可設routeName和傳送參數(物件型別)
    // 2. builder-->屬性值型別為WidgetBuilder，回傳screen widget
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ForgotPasswordScreen(),
    );
  }

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 使用validate()方法
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 取得文字框的值
  TextEditingController _controller = TextEditingController();
  bool isEmailExist;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('忘記密碼'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '請輸入註冊時的電子郵件重設密碼',
              style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '電子郵件',
                    // 有外框後，不想框太大要調整contentPadding
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      gapPadding: 0.0,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // _controller.text不會自動有值，需要透過onChanged或onSaved賦值
                  onChanged: (value) => _controller.text = value,
                  validator: (value) {
                    return isEmailExist ? null : '此電子郵件尚未註冊！';
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomElevatedButton(
              text: '送出',
              onPressed: () async {
                // 因為validator不能用非同步，所以要將函式(_checkEmail)獨立
                // 在按鈕的onPressed callback呼叫取得布林值
                // 再用setState更新全域變數isEmailExist(在validator callback裡面判斷)
                print('value:${_controller.text}');
                var response = await _checkEmail(_controller.text);
                // setState不可使用非同步
                setState(() => isEmailExist = response);
                // 下一步檢查是否符合驗證
                if (_formKey.currentState.validate()) {
                  AuthRepository _authRepository = AuthRepository();
                  // 這是登出時讀取firestore，所以要修改firestore rules

                  _authRepository.resetPassword(email: _controller.text);
                  // 導向webview
                  Navigator.of(context).pushNamed(
                    WebviewScreen.routeName,
                    arguments: WebviewScreenArgs(
                      title: '重設密碼',
                      flushBarMessage: '請至maxmarco0311@gmail.com收信，完成重設密碼程序',
                      sourcePage: 'forgotPassword',
                    ),
                  );
                }
              },
              // 按鈕寬度要看水平padding決定
              edgeInset:
                  const EdgeInsets.symmetric(horizontal: 120.0, vertical: 10.0),
              fontSize: 18.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkEmail(String email) async {
    UserRepository _userRepository = UserRepository();
    return await _userRepository.isEmailExist(email: email);
  }
}

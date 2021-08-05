import 'package:equatable/equatable.dart';

// Firebase Auth錯誤訊息的自訂物件
class Failure extends Equatable {
  // 錯誤大類
  // final String code;
  // 細部訊息
  final String message;
  // 建構式：兩個屬性給空字串預設值
  const Failure({this.message = ''});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [message];
}

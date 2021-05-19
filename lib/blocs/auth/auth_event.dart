part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [];
}

// 定義UI行為所觸發的事件
// 一個事件必須是個一個類別(繼承AuthEvent)
// 類別屬性資料可供bloc中mapEventToState()方法內運算或更新狀態
class AuthUserChanged extends AuthEvent {
  final auth.User user;

  const AuthUserChanged({@required this.user});

  @override
  List<Object> get props => [user];
}

// 沒有任何屬性的事件類別
class AuthLogoutRequested extends AuthEvent {}

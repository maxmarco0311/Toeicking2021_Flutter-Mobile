part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unverified, unauthenticated }

// 定義authentication需要的資料(state)
class AuthState extends Equatable {
  // firebase的user物件
  final auth.User user;
  // 狀態
  final AuthStatus status;

  const AuthState({
    // 兩個屬性都是非必要
    this.user,
    this.status = AuthStatus.unknown,
  });

  // 登出或尚未註冊-->空的state物件
  factory AuthState.unknown() => const AuthState();

  // 註冊後且通過Email驗證(參數user是Firebase Auth傳來的Stream當中的user)
  factory AuthState.authenticated({@required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.authenticated);
  }

  // 註冊後但還沒通過Email驗證(參數user是Firebase Auth傳來的Stream當中的user)
  factory AuthState.unverified({@required auth.User user}) {
    return AuthState(user: user, status: AuthStatus.unverified);
  }

  // 登出(此時Firebase Auth傳來的Stream當中的user是null，所以也不用賦值)
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [user, status];
}



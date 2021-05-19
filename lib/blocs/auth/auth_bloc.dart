import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';
import 'package:toeicking2021/repositories/auth/auth_repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User> _userSubscription;

  AuthBloc({
    @required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        // 初始狀態為unknown
        super(AuthState.unknown()) {
    // _authRepository.user回傳Stream<User>，所以可使用listen()，訂閱這個Stream(有值進來會通知)
    // 只要每當Stream中有一個新的(FirebaseAuth)User物件進來(signin,login,logout都會)
    // 就會觸發參數函式並傳入該User，該函式使用add()方法通知bloc有一個新的event
    // 傳入參數為一個AuthUserChanged(事件)物件，其屬性值就用Stream傳進來的User
    // 並觸發mapEventToState()方法
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  // async*表方法回傳Stream(一次一次的回傳值)，async則是回傳Future(等待一段時間一次性回傳值)
  // *表這是個generator function，表這個方法會分好多次，每次回傳一個值(同步是Iterable，非同步是Stream)
  // 此方法觸發時代表UI行為(或stream subscription)中有觸發已定義好的事件，例如add(AuthUserChanged(user: user))
  // UI中該bloc所有add()方法觸發時都會呼叫此方法並傳入一種AuthEvent事件物件(不同情況傳入不同物件)
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // 處理所有定義的事件
    if (event is AuthUserChanged) {
      // yield*表呼叫(或委派)另一個會回傳Stream的generator function-->_mapAuthUserChangedToState()
      // 參數event表AuthUserChanged(事件)物件，有包含傳進來的屬性資料user
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _authRepository.logOut();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    // yield表回傳這個stream中的一個值
    // yield event.user != null
    //     ? AuthState.authenticated(user: event.user)
    //     : AuthState.unauthenticated();
    if (event.user != null) {
      // 檢查是否有通過Email驗證
      if (event.user.emailVerified) {
        AuthState.authenticated(user: event.user);
      } else if (!event.user.emailVerified) {
        AuthState.unverified(user: event.user);
      }
    } else {
      AuthState.unauthenticated();
    }
  }
}

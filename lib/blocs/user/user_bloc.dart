import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:toeicking2021/blocs/auth/auth_bloc.dart';
import 'package:toeicking2021/repositories/api/api_repository.dart';
import 'package:toeicking2021/repositories/repositories.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthBloc _authBloc;
  APIRepository _apiRepository;
  UserRepository _userRepository;

  UserBloc({
    @required AuthBloc authBloc,
    @required APIRepository apiRepository,
    @required UserRepository userRepository,
  })  : _authBloc = authBloc,
        _apiRepository = apiRepository,
        _userRepository = userRepository,
        super(
          UserState.initial(),
        );

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButtonPressed);
  }
//make bloc events
  FutureOr<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginState> emit
  ) {

  }

  FutureOr<void> _onLogoutButtonPressed(
      LogoutButtonPressed event,
      Emitter<LoginState> emit
  ) {

  }
}

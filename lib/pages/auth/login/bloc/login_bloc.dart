import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(LoginState()) {
    on<LoginButtonPressedEvent>(_handleLoginWithEmailAndPasswordEvent);
    on<LoginEmailChangeEvent>(_handleLoginEmailChangeEvent);
    on<LoginPasswordChangeEvent>(_handleLoginPasswordChangeEvent);
    on<LoginTurnOffMessageEvent>(_handleLoginTurnOffMessageEvent);
  }
  final AuthService _authService;

  Future<void> _handleLoginWithEmailAndPasswordEvent(
    LoginButtonPressedEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      await _authService.signIn(
        email: state.email,
        password: state.password,
      );
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        return emit(state.copyWith(
          message: 'Sucess',
          status: LoginStatus.success,
        ));
      } else if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        return emit(state.copyWith(
          message: 'Loading',
          status: LoginStatus.loading,
        ));
      } else {
        return emit(state.copyWith(
          message: 'Loading',
          status: LoginStatus.loading,
        ));
      }
    } catch (e) {
      return emit(state.copyWith(
        message: 'Failure',
        status: LoginStatus.failure,
      ));
    }
    return emit(state.copyWith(
      message: 'Failure',
      status: LoginStatus.failure,
    ));
  }

  Future<void> _handleLoginEmailChangeEvent(
    LoginEmailChangeEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleLoginPasswordChangeEvent(
    LoginPasswordChangeEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _handleLoginTurnOffMessageEvent(
    LoginTurnOffMessageEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.off));
  }
}

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';
import 'package:mefl_app_bloc/repository/user_repo.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(SignupState()) {
    on<SignupButtonPressedEvent>(_handleSignupWithEmailandPasswordEvent);
    on<SignupEmailChangeEvent>(_handleSignupEmailChangeEvent);
    on<SignupPasswordChangeEvent>(_handleSignupPasswordChangeEvent);
    on<SignupUsernameChangeEvent>(_handleSignupUsernameChangeEvent);
  }

  final AuthService _authService;

  Future<void> _handleSignupWithEmailandPasswordEvent(
    SignupButtonPressedEvent event,
    Emitter<SignupState> emit,
  ) async {
    try {
      await _authService.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      await UserRepo().store(email: state.email, name: state.username);
      if (FirebaseAuth.instance.currentUser != null) {
        emit(state.copyWith(
          message: 'Succes',
          status: SignupStatus.success,
        ));
      } else {
        emit(state.copyWith(
          message: 'Failure',
          status: SignupStatus.failure,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Failure',
        status: SignupStatus.failure,
      ));
    }
  }

  Future<void> _handleSignupEmailChangeEvent(
    SignupEmailChangeEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _handleSignupUsernameChangeEvent(
    SignupUsernameChangeEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(username: event.username));
  }

  Future<void> _handleSignupPasswordChangeEvent(
    SignupPasswordChangeEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _handleSignupTurnOffMessageEvent(
    SignupTurnOffMessageEvent event,
    Emitter<SignupState> emit,
  )async{
    emit(state.copyWith(status: SignupStatus.off));
  }
}

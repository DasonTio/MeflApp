part of 'login_bloc.dart';
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginButtonPressedEvent extends LoginEvent {
  const LoginButtonPressedEvent();
}

class LoginEmailChangeEvent extends LoginEvent {
  const LoginEmailChangeEvent({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChangeEvent extends LoginEvent {
  const LoginPasswordChangeEvent({
    required this.password,
  });

  final String password;

  @override
  List<Object?> get props => [password];
}

class LoginTurnOffMessageEvent extends LoginEvent{
  LoginTurnOffMessageEvent();
}


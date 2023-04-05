part of 'signup_bloc.dart';

  abstract class SignupEvent extends Equatable {
    const SignupEvent();

    @override
    List<Object?> get props => [];
  }

class SignupButtonPressedEvent extends SignupEvent {
  const SignupButtonPressedEvent();
}

class SignupEmailChangeEvent extends SignupEvent {
  const SignupEmailChangeEvent({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChangeEvent extends SignupEvent {
  const SignupPasswordChangeEvent({required this.password});

  final String password;

  @override
  List<Object?> get props => [password];
}

class SignupUsernameChangeEvent extends SignupEvent {
  const SignupUsernameChangeEvent({
    required this.username,
  });

  final String username;

  @override
  List<Object?> get props => [username];
}

class SignupTurnOffMessageEvent extends SignupEvent{
  SignupTurnOffMessageEvent();
}
part of 'signup_bloc.dart';

enum SignupStatus {
  success,
  failure,
  loading,
  off,
}

class SignupState extends Equatable {
  SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.message = '',
    this.status = SignupStatus.off,
  });

  final String username;
  final String message;
  final SignupStatus status;
  final String email;
  final String password;

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    SignupStatus? status,
    String? message,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        message,
        status,
        username,
        email,
        password,
      ];
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/pages/auth/login/login_view.dart';
import 'package:mefl_app_bloc/pages/auth/signup/bloc/signup_bloc.dart';
import 'package:mefl_app_bloc/pages/auth/signup/signup_page.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  static String route = '/signup';

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthService(auth: FirebaseAuth.instance),
      child: BlocProvider(
        create: (context) =>
            SignupBloc(authService: context.read<AuthService>()),
        child: SignupPage(),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/components/input_box.dart';
import 'package:mefl_app_bloc/pages/auth/login/bloc/login_bloc.dart';
import 'package:mefl_app_bloc/pages/auth/login/login_page.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  static String route = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RepositoryProvider(
      create: (context) => AuthService(auth: FirebaseAuth.instance),
      child: BlocProvider(
        create: (context) => LoginBloc(authService: context.read<AuthService>()),
        child: LoginPage(),
      ),
    );
  }
}

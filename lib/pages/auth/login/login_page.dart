import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/components/input_box.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/pages/auth/login/bloc/login_bloc.dart';
import 'package:mefl_app_bloc/pages/auth/signup/signup_view.dart';
import 'package:mefl_app_bloc/pages/home/home_page.dart';
import 'package:mefl_app_bloc/pages/home/home_view.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: ((context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamed(context, HomeView.route);
          } else {
            if (state.status == LoginStatus.loading) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Verify Your Email')));
            } 
          }
            context.read<LoginBloc>().add(LoginTurnOffMessageEvent());
        }),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: SizeConfig.blockWidth,
              height: SizeConfig.blockHeight,
              alignment: Alignment.bottomCenter,
              color: lightPrimaryColor,
              child: Container(
                width: SizeConfig.blockWidth!,
                height: SizeConfig.blockHeight! / 2,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(deafultRadius),
                      topRight: Radius.circular(deafultRadius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 20.0,
                        blurStyle: BlurStyle.normal,
                      ),
                    ]),
                padding: EdgeInsets.all(SizeConfig.blockHorizontal! * 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Login",
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 6,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockVertical! * 3,
                    ),
                    InputBox(
                      icon: Icon(Icons.email),
                      hint: "Email",
                      onChanged: (value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginEmailChangeEvent(email: value));
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockVertical! * 2,
                    ),
                    InputBox(
                      icon: Icon(Icons.lock),
                      hint: "Password",
                      isHidden: true,
                      onChanged: (value) {
                        context
                            .read<LoginBloc>()
                            .add(LoginPasswordChangeEvent(password: value));
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockVertical! * 4,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, SignupView.route),
                      child: Text("Don't have account yet? Sign up"),
                    ),
                    Button(
                      name: "Sign In",
                      onPress: () {
                        context
                            .read<LoginBloc>()
                            .add(LoginButtonPressedEvent());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

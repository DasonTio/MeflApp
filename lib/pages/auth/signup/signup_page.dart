import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/components/input_box.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/pages/auth/login/bloc/login_bloc.dart';
import 'package:mefl_app_bloc/pages/auth/signup/bloc/signup_bloc.dart';
import 'package:mefl_app_bloc/pages/home/home_view.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignupBloc, SignupState>(
        listener: ((context, state) {
          if (state.status == SignupStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Verification has been sent")));
            Navigator.pop(context);
          } else {
            if(state.status == SignupStatus.loading){

            }
          }
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
                height: SizeConfig.blockHeight! / 1.7,
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("BACK"),
                    ),
                    Text(
                      "Signup",
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 6,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockVertical! * 3),
                    InputBox(
                      icon: Icon(Icons.person),
                      hint: "Username",
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupUsernameChangeEvent(username: value));
                      },
                    ),
                    SizedBox(height: SizeConfig.blockVertical! * 2),
                    InputBox(
                      icon: Icon(Icons.email),
                      hint: "Email",
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupEmailChangeEvent(email: value));
                      },
                    ),
                    SizedBox(height: SizeConfig.blockVertical! * 2),
                    InputBox(
                      icon: Icon(Icons.lock),
                      hint: "Password",
                      isHidden: true,
                      onChanged: (value) {
                        context
                            .read<SignupBloc>()
                            .add(SignupPasswordChangeEvent(password: value));
                      },
                    ),
                    SizedBox(height: SizeConfig.blockVertical! * 4),
                    Button(
                      name: "Sign In",
                      onPress: () async {
                        context
                            .read<SignupBloc>()
                            .add(SignupButtonPressedEvent());
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

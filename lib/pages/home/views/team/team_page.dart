import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/components/button.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/team/pages/team_many_page.dart';
import 'package:mefl_app_bloc/pages/home/views/team/pages/team_single_page.dart';
import 'package:mefl_app_bloc/services/user_service.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    userService.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder(
      bloc: context.read<TeamBloc>(),
      builder: (context, state) {
        return SingleChildScrollView(
          child: SafeArea(
            child: StreamBuilder(
              stream: userService.authUser,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error Occured"),
                  );
                }
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  if (user.teamId != "") return TeamManyPage();
                  else return TeamSinglePage();
                }
                return Container(
                  height: SizeConfig.blockHeight,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/pages/home/home_page.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/add/bloc/menu_add_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/edit/bloc/menu_edit_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/profile/bloc/profile_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  static String route = '/HomeView';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => {},
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TeamBloc>(create: ((context) => TeamBloc())),
          BlocProvider<ProfileBloc>(create: ((context) => ProfileBloc())),
          BlocProvider<MenuBloc>(create: ((context) => MenuBloc())),
          BlocProvider<MenuAddBloc>(create: (context) => MenuAddBloc()),
          // BlocProvider<MenuEditBloc>(create: (context) => MenuEditBloc()),
        ],
        child: HomePage(),
      ),
    );
  }
}

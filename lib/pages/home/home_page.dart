import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/constant/size_config.dart';
import 'package:mefl_app_bloc/layout/header.dart';
import 'package:mefl_app_bloc/pages/auth/login/login_view.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/bloc/menu_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/menu_page.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/add/bloc/menu_add_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/add/menu_add_page.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/edit/bloc/menu_edit_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/edit/menu_edit_page.dart';
import 'package:mefl_app_bloc/pages/home/views/profile/bloc/profile_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/profile/profile_page.dart';
import 'package:mefl_app_bloc/pages/home/views/team/bloc/team_bloc.dart';
import 'package:mefl_app_bloc/pages/home/views/team/team_page.dart';
import 'package:mefl_app_bloc/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  int _currentIndex = 0;
  List<Widget> _pages = [
    MenuPage(),
    TeamPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: whiteColor,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockVertical!,
            ),
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    elevation: 0,
                    backgroundColor: accentColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.close,
                    color: accentColor,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.blockVertical! * 4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding - 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 6,
                        color: blackColor,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: mediumFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 4,
                        color: blackColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockVertical! * 3,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<MenuAddBloc>(context),
                        child: MenuAddPage(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding - 4,
                    vertical: SizeConfig.blockVertical! * 3,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: accentColor,
                    ),
                    SizedBox(width: SizeConfig.blockHorizontal! * 5),
                    Text(
                      "Tambah Menu",
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 5,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<MenuBloc>(context),
                        child: MenuEditPage(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding - 4,
                    vertical: SizeConfig.blockVertical! * 3,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: accentColor,
                    ),
                    SizedBox(width: SizeConfig.blockHorizontal! * 5),
                    Text(
                      "Edit Menu",
                      style: boldFont.copyWith(
                        fontSize: SizeConfig.blockHorizontal! * 5,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: SizeConfig.blockHeight! / 1.78,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(
                            context, LoginView.route);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding - 4,
                          vertical: SizeConfig.blockVertical! * 3,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: accentColor,
                          ),
                          SizedBox(width: SizeConfig.blockHorizontal! * 5),
                          Text(
                            "Logout",
                            style: boldFont.copyWith(
                              fontSize: SizeConfig.blockHorizontal! * 5,
                              color: accentColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: ((value) => setState(() {
              _currentIndex = value;
            })),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Teams",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
          ),
        ],
      ),
      body: _pages[_currentIndex],
    );
  }
}

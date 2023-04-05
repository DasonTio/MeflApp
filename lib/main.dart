import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mefl_app_bloc/constant/constant.dart';
import 'package:mefl_app_bloc/firebase_options.dart';
import 'package:mefl_app_bloc/pages/auth/login/login_view.dart';
import 'package:mefl_app_bloc/pages/auth/signup/signup_view.dart';
import 'package:mefl_app_bloc/pages/home/home_view.dart';
import 'package:mefl_app_bloc/pages/home/views/menu/pages/add/menu_add_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initRoute = "/";
  @override
  void initState() {
    checkUser();
  }

  Future<void> checkUser() async {
    if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) {
      setState(() => initRoute = HomeView.route);
    } else {
      setState(() => initRoute = LoginView.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(backgroundColor: backgroundColor),
      initialRoute: initRoute,
      routes: {
        HomeView.route: (context) => HomeView(),
        LoginView.route: (context) => LoginView(),
        SignupView.route:(context) => SignupView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

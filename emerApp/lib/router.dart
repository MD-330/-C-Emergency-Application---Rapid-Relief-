import 'package:Emergency/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Emergency/screen/splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/start_screen.dart';


class Router1 {
  static const login = 'login';
  static const register = 'register';

  static const Home = 'Home';
  static const Splash = 'Splash';
  static const Start = 'Start';


  static const initialRoute = Splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        switch (settings.name) {

          // case Companies:
          //   return CompaniesScreen(initialIndex: 0);
          case Splash:
            return SplashScreen();
          case Start:
            return StartScreen();
          case Home:
            return HomeScreen(initialIndex: 0,);
          case register:
            return SignupScreen();
          case login:
            return LoginScreen();

          default:
            return Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            );
        }
      },
    );
  }
}
// Ignoring header X-Firebase-Locale because its value was null.
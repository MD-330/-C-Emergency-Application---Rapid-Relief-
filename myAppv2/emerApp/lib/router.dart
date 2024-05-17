import 'package:Emergency/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Emergency/screen/splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/start_screen.dart';
//he Router1 class is defined to manage the routing of the application.
// Constants like login, register, Home, Splash, and Start are declared to

class Router1 {
  static const login = 'login';
  static const register = 'register';

  static const Home = 'Home';
  static const Splash = 'Splash';
  static const Start = 'Start';


  static const initialRoute = Splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute( //define a set of routes for a Flutter application using
      settings: settings, //the MaterialPageRoute class
      //The application seems to have multiple screens or pages, and each screen is associated with a specific route
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
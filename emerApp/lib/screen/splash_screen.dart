// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Emergency/main.dart';

import 'package:Emergency/util/global_data.dart';
import 'package:Emergency/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/start_screen.dart';
import '../model/user_model.dart';
import '../util/project_function.dart';
import '../util/sharedPref.dart';
import '../values/sizeHelper.dart';

import 'home_screen.dart';
import 'home_screen_admin.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome1();
  }
  late SharedPreferences prefs;
  late SharedPref sharedPref;
  _navigateToHome1() async {
    await Future.delayed(const Duration(seconds: 2));
    prefs = await SharedPreferences.getInstance();
    sharedPref = SharedPref();
    if (FirebaseAuth.instance.currentUser != null) {
      if (prefs.containsKey("userInfo")) {
        GlobalData.currentUser =
            UserModel.fromJson(await sharedPref.read("userInfo"));
        checkSetId(GlobalData.currentUser);
        // GlobalData.currentUser.
    String? username=GlobalData.currentUser.username;
      }
      else {
        try {
          UserModel userModel =
          await getUserInfo1(FirebaseAuth.instance.currentUser!.uid);
          if (userModel.uid != null) {
            sharedPref.save("userInfo", userModel.toMap());
            print(userModel.setId);
            GlobalData.currentUser = userModel;
            checkSetId(GlobalData.currentUser);
          }
        } catch (error) {
          print(error);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>  StartScreen()));

        }
      }
    }
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  StartScreen()));
  }
  checkSetId(user) async {
    print(user.setId);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => user.setId!='user'? HomeScreenAdmin():HomeScreen(initialIndex: 0,)));
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.setHeight(100),
          ),
          Text('Welcome to ',
              style: TextStyle(
                  fontSize: size.setWidth(32),
                  fontFamily: 'Aller',
                  fontWeight: FontWeight.bold),),
          SizedBox(
            height: size.setHeight(20),
          ),
          Container(
            height: size.setHeight(200),
            // width: double.infinity,
            child:Image.asset( GlobalData.logo,fit: BoxFit.contain,),
          ),
          SizedBox(
            height: size.setHeight(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Emergency ',
                style: TextStyle(
                    fontSize: size.setWidth(27),
                    fontFamily: 'Aller',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),),
              Text('Application ',
                style: TextStyle(
                    fontSize: size.setWidth(22),
                    fontFamily: 'Aller',
                    color: AppColors. blackShade5,
                    fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(
            height: size.setHeight(10),
          ),
          SpinKitWave(
            size: size.setWidth(70),
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}

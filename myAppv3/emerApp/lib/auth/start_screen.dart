import 'dart:math';

import 'package:Emergency/auth/signup_screen.dart';
import 'package:Emergency/util/global_data.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login_screen.dart';
import '../screen/setting_screen.dart';
import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/custom_button.dart';
import '../widget/global_wedgit.dart';
import '../widget/login_widget.dart';
import 'start_screen3.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int val = 1;

  @override
  void initState() {
    super.initState();
  }

  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    App.setLocale(context, _locale);
  }

  Widget getAppBarUI() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      title: Text(
        "",
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        DropdownButton<Language>(
          icon:
              Container(margin: EdgeInsets.only(left: 10, right: 10), child: Icon(Icons.language, color: Colors.white)),
          iconSize: 30,
          onChanged: (Language? language) {
            _changeLanguage(language!);
          },
          items: Language.languageList()
              .map<DropdownMenuItem<Language>>(
                (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                        width: 100,
                        child: Text(e.name, style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var side = 650.0;
    var sizeSmall = 600.0;
    var sideRight = 250.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(children: <Widget>[

        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -230,
                left: -10,
                right: 10,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment(0.0, 0.25),
                    child: Transform.rotate(
                      angle: pi / 2.9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(1),
                          borderRadius: BorderRadius.all(Radius.circular(140)),
                        ),
                        height: side,
                        // width: side,
                        child: Transform.rotate(
                          angle: -pi / 4,
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[])),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SpaceH12(),
              Positioned(
                top: 110,
                left: 10,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SpaceH20(),
                              Container(
                                // width: 30,
                                child: Image.asset(
                                  GlobalData.logoWait,
                                  // GlobalData.logo,
                                  fit: BoxFit.contain,
                                  width: 130,
                                  // height: 100,
                                ),
                              ),
                              Expanded(child: Text(
                                'Emergency Application - Rapid Relief',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: AppColors.white.withOpacity(.9),
                                  fontSize: 20,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold
                                ),
                              ),)

                            ])),
                  ])),

              Positioned(
                top: size.height*.47,
                left: 40,
                right: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    SpaceH30(),
                    Container(
                      child: CustomButton(
                        color: AppColors.primary,
                        borderColor: AppColors.primary,
                        textColor: AppColors.white,
                        text: getTranslated(context, 'logIn'),
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => StartScreen3()));
                        },
                      ),
                    ),
                    SpaceH30(),
                    Container(
                      child: CustomButton(
                        color: AppColors.white,
                        borderColor: AppColors.blackShade9,
                        textColor: AppColors.allLabel,
                        text: getTranslated(context, 'signUp'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        },
                      ),
                    ),
                    SpaceH30(),

                    buildOtherLogins(context),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:    Container(
                  // height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/Images/img9.jpg",
                      fit: BoxFit.contain,
                      // width: MediaQuery.of(context).size.width,
                      // height: 150,
                      // color: color,
                    ),
                  ),
                ),),
              Positioned(top: 0, left: 0, right: 0, child: getAppBarUI()),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 120,
        //   right: -60,
        //   child: Container(
        //       height: size.height * .13,
        //       decoration: BoxDecoration(
        //           color: AppColors.primary.withOpacity(.8),
        //           borderRadius: BorderRadius.only(topLeft: Radius.circular(49), topRight: Radius.circular(49))),
        //       alignment: Alignment.center,
        //       child: Container(
        //         child: Padding(
        //             padding: EdgeInsets.all(6),
        //             child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   Expanded(
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         getIconSocial('google.png'),
        //                         widthSpacer(15.00),
        //                         getIconSocial('facebook.png'),
        //                         widthSpacer(15.00),
        //                         getIconSocial('twitter.png'),
        //                       ],
        //                     ),
        //                   )
        //                 ])),
        //       )),
        // ),
        // Positioned(
        //   bottom: size.height * .106,
        //   left: 120,
        //   right: -60,
        //   child: Container(
        //       alignment: Alignment.center,
        //       child: Container(
        //         child: Padding(
        //             padding: EdgeInsets.all(6),
        //             child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   Expanded(
        //                       child: Text(
        //                     'Sign In via',
        //                     textAlign: TextAlign.center,
        //                     style:
        //                         TextStyle(fontSize: 22.00, fontWeight: FontWeight.w500, color: AppColors.blackShade2),
        //                   ))
        //                 ])),
        //       )),
        // ),
      ]),
    );
  }
}
// EmergencyApp

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../main.dart';
import '../screen/setting_screen.dart';
import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/custom_button.dart';
import 'login_screen.dart';
import 'dart:ui' as prefix0;

class StartScreen3 extends StatefulWidget {
  @override
  _StartScreen3State createState() => _StartScreen3State();
}

class _StartScreen3State extends State<StartScreen3>  with TickerProviderStateMixin{
  final double topPolygonSize = 300;
  final double curvedBackgroundRadius = 100;
   late double curvedBackgroundTopPosition ;
  final double curvedBackgroundAngle = 31;
  late double curvedBackgroundLeftPosition;
  bool isLogin = true;
  late AnimationController _logoController;

  late AnimationController _formController;
  late AnimationController _formButtonController;
  late Animation _logoSlideAnimation;
  late Animation<double> _formOpacityAnimation;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );


  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    App.setLocale(context, _locale);
  }

  @override
  void initState() {
    super.initState();
    curvedBackgroundLeftPosition =
        (math.sqrt(math.pow(100, 2) + math.pow(100, 2))) -
            curvedBackgroundRadius;
    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _formController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _formButtonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _logoSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _logoController,
            curve: Interval(0, 1.0, curve: Curves.easeIn)));
    _formOpacityAnimation =
        CurvedAnimation(parent: _formController, curve: Curves.easeIn);
    _logoController
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _formController.forward();
        }
      })
      ..forward();
    _formController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _formButtonController.forward();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _logoController.dispose();
    _formController.dispose();
    _formButtonController.dispose();
  }
  Widget getAppBarUI() {
    return  AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      title:  Text(
        "",
        style:  TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        DropdownButton<Language>(
          icon: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Icon(Icons.language, color: Colors.white)),

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
    setState(() {
      curvedBackgroundTopPosition = MediaQuery.of(context).size.height*.28;
    });
    Size size=MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0XFF313131),
        body: Form(
            child: Stack(children: <Widget>[
              // Container(
              //   width: size.width,
              //   height: size.height*.55,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/images/bb7.jpeg"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            Row(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height*.55,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Images/back2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ]),



              // BackdropFilter(
              //     filter: prefix0.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              //     child: Container(
              //       decoration:
              //       BoxDecoration(color: Colors.black.withOpacity(0.1)),
              //     )),
              _curvedBackContainer(
                  AppColors.primary3.withOpacity(.9),
                  curvedBackgroundTopPosition - 13,
                  curvedBackgroundLeftPosition - 2,size.width),
              _curvedBackContainer(AppColors.white, curvedBackgroundTopPosition,
                  curvedBackgroundLeftPosition,size.width),
              _backgroundContainer(),
             // _buildTopPolygon(),
             //  _buildLogoText(),
              Container(
                padding: EdgeInsets.only(top: curvedBackgroundTopPosition+140, left: 40, right: 40),
                child: _buildFormContent(),
              ),
              Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: size.width,
                    height: 2,
                    color: AppColors.primary3,
                  ),),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: getAppBarUI()),
            ])));
  }

  _curvedBackContainer(Color color, double topPosition, double leftPosition,double width) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Positioned(
        top: topPosition,
        left: leftPosition,
        child: Transform.rotate(
            angle: _degreesToRadian(curvedBackgroundAngle),
            alignment: FractionalOffset.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(curvedBackgroundRadius)),
                color: color,
              ),
              width: deviceWidth /
                  math.cos(_degreesToRadian(curvedBackgroundAngle)),
              // width: width*2,

              height: math
                  .sqrt(math.pow(deviceWidth, 2) + math.pow(deviceWidth, 2)),
            )));
  }
  _backgroundContainer() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double backgroundTopMargin = curvedBackgroundTopPosition +
        (deviceWidth * math.tan(_degreesToRadian(curvedBackgroundAngle)));
    return Padding(
        padding: EdgeInsets.only(top: backgroundTopMargin+40),
        child: Container(
          color: AppColors.white,
        ));
  }
  _buildFormContent() {
    return Container(
      height: MediaQuery.of(context).size.height*.7,
        child:SingleChildScrollView(
            child: Column(
            children: <Widget>[
              _buildFormFields(),
              const SizedBox(
                height: 60,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     SocialIcon(
              //         icon: "facebook.png",
              //         color: AppColors.primary3,
              //         onPressed: () {}),
              //     SpaceW16(),
              //     SocialIcon(
              //         icon: "google.png", color: AppColors.primary3,  onPressed: () {
              //      }),
              //     SpaceW16(),
              //     SocialIcon(
              //         icon: "twitter.png", color: AppColors.primary3, onPressed: () {
              //         }),
              //
              //   ],
              // ),
            ])));
  }
  _welcomeText() {
    return Container(
         alignment: Alignment.centerLeft,
     child: Text(
       getTranslated(context, 'welcome'),
        textAlign: TextAlign.left,
        style: TextStyle(color: AppColors.black.withOpacity(.9),
            fontSize: 24,
          ),
      ),
    );
  }

  _buildFormFields() {
    return FadeTransition(
        opacity: _formOpacityAnimation,
        child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              _welcomeText(),
              const SizedBox(
                height: 30,
              ),
              Container(
                // margin: const EdgeInsets.only(
                //     left: 20, right: 20),
                child:  CustomButton(
                  color: AppColors.primary3,
                  borderColor: AppColors.primary3,
                  textColor: AppColors.white,
                  text:   getTranslated(context, 'logIn'),
                  // check: true,
                  // radius: 50.0,
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             LoginScreen3(
                    //               manage: 'login',
                    //             )));
                  },
                ),
              ),
              SpaceH24(),

              Container(
                // margin: const EdgeInsets.only(
                //     left: 20, right: 20),
                child:  CustomButton(
                  color: AppColors.white,
                  borderColor: AppColors.primary.withOpacity(.5),
                  textColor: AppColors.primary,
                  text: getTranslated(context, 'signUp'),
                  // check: false,
                  // radius: 50.0,
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             LoginScreen3(
                    //                 manage:
                    //                 'register')));
                  },
                ),
              ),
              SpaceH16(),


              SpaceH8(),

              const TextField(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Label Name 1',
                  hintText: 'Hint Text 1',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),

              SpaceH8(),
              const SizedBox(
                height: 10,
              ),


            ]));
  }
  _buildAuthNavigation() {
    return Row(children: <Widget>[
      Text(
        'Sign up',
        style: TextStyle(color: Colors.black.withOpacity(.8), fontSize: 30),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 8.0, right: 4.0),
        child: Text(
          '/',
          style: TextStyle(color: AppColors.black, fontSize: 20),
        ),
      ),
      GestureDetector(
          child: Text(
            'LOGIN',
            style: TextStyle(color: Colors.black.withOpacity(.8), fontSize: 20),
          ),
          onTap: () {
            // _formController.reset();
            // _formButtonController.reset();
            // _formController.forward();
            // setState(() {
            //   isLogin = !isLogin;
            // });
          }
      )
    ]);
  }

  double _degreesToRadian(double degrees) {
    return degrees * math.pi / 180;
  }
}
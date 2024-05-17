import 'dart:io';
import 'dart:math' as math;

import 'package:Emergency/util/global_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../api/authController.dart';
import '../api/userDataController.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../router.dart';
import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/GradientSnackBar.dart';
import '../widget/custom_button.dart';
import '../widget/custom_input_field.dart';
import '../widget/login_widget.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final double topPolygonSize = 270;
  final double curvedBackgroundRadius = 100;
  late double curvedBackgroundTopPosition;
  Color textColor = AppColors.blackShade2;
  Color radiusColor = AppColors.primary;
  final double curvedBackgroundAngle = 31;
  late double curvedBackgroundLeftPosition;
  bool isLogin = true;
  bool checkValidation = false;
  bool hidePass = true;
  IconData iconPass = Icons.visibility;
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _formButtonController;
  late Animation _logoSlideAnimation;
  late Animation _buttonSlideAnimation;
  late Animation<double>? animation;
  double radius = 10.0;
  double radius1 = 50.0;
  UserModel userModel = UserModel();
  var _isLoading = false;

  Color labelColor = AppColors.primary;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  void _loginFunction() async {                                                      // log in function
    FocusScope.of(context).unfocus();
    if ((userModel.password!.isEmpty || userModel.email!.isEmpty)) {
      GradientSnackBar.showError(context, "Fields cannot be empty");
      return;
    }
    if (!userModel.email!.contains('@') || !userModel.email!.contains('.com')) {
      GradientSnackBar.showError(context, 'The email address is badly formatted');
      return;
    }
    if (userModel.password!.length < 6) {
      GradientSnackBar.showError(context, "password must be at least 6 characters.");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthenticationController>(context, listen: false)
          .login(userModel.email!, userModel.password!)  //log in
          .whenComplete(() async {
        await Provider.of<UserDataController>(context, listen: false)
            .getUserDataById(globalUserId)
            .whenComplete(() {
          Navigator.of(context).pushReplacementNamed(
              globalUserId != null && globalUserId != ''
                  ? Router1.Splash
                  : '');
        });
      });
    } on HttpException catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, "Invalid username or password ");
      return;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, "Invalid username or password ");
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    userModel.email = '';
    userModel.password = '';
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
    animation =
        CurvedAnimation(parent: _formController, curve: Curves.easeIn);

    _buttonSlideAnimation = Tween<double>(begin: 2.2, end: 0.0).animate(
        CurvedAnimation(
            parent: _formButtonController,
            curve: Interval(0, 1.0, curve: Curves.easeIn)));
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    setState(() {
      curvedBackgroundTopPosition = MediaQuery.of(context).size.height * .2;
    });
    return Scaffold(
        backgroundColor: Color(0XFF313131),
        body: SingleChildScrollView(
            child: Container(
                height: size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: <Widget>[
                  Container(
                    height: size.height * .5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Images/back2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  _curvedBackContainer(
                      AppColors.primary3.withOpacity(.8),
                      curvedBackgroundTopPosition - 13,
                      curvedBackgroundLeftPosition - 2),
                  _curvedBackContainer(
                      AppColors.white,
                      curvedBackgroundTopPosition,
                      curvedBackgroundLeftPosition),
                  _backgroundContainer(),
                  _buildTopPolygon(),
                  _buildLogoText(),
                  Container(
                    padding: EdgeInsets.only(top: size.height*.28, left: 20, right: 20),
                    child: _buildFormContent(),
                  ),

                ]))));
  }

  _buildTopPolygon() {
    return Positioned(
        top: -1 * (25 / 100 * topPolygonSize),
        right: -1 * (23 / 100 * topPolygonSize),
        child: Container(
            height: topPolygonSize,
            width: topPolygonSize,
            child: ClipPolygon(
                sides: 6,
                borderRadius: 10,
                child: Container(
                  color: AppColors.white,
                ))));
  }

  _buildLogoText() {
    return Positioned(
        top: 30,
        right: 30,
        child: AnimatedBuilder(
            animation: _logoSlideAnimation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    0, _logoSlideAnimation.value * 100, 0),
                child: Image.asset(
                  GlobalData.logo,
                  // width: 200,
                  height: 120,
                  // color: AppColors.white,
                ),
              );
            }));
  }

  _curvedBackContainer(Color color, double topPosition, double leftPosition) {
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
              //width:  MediaQuery.of(context).size.width,
              height: math
                  .sqrt(math.pow(deviceWidth, 2) + math.pow(deviceWidth, 2)),
            )));
  }

  _backgroundContainer() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double backgroundTopMargin = curvedBackgroundTopPosition +
        (deviceWidth * math.tan(_degreesToRadian(curvedBackgroundAngle)));
    return Padding(
        padding: EdgeInsets.only(top: backgroundTopMargin),
        child: Container(
          color: AppColors.white,
        ));
  }

  _buildFormContent() {
    return Container(
        height: MediaQuery.of(context).size.height * .8,
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpaceH50(),
              _buildAuthNavigation(),
              SpaceH30(),
              _buildFormFields(),
              SpaceH20(),
              if (_isLoading)
                SpinKitPianoWave(
                  color: AppColors.primary,
                )
              else
              Container(

                  width: MediaQuery.of(context).size.width,
                  child: _buildFormButton()),

             SpaceH20(),
              buildOtherLogins(context),
              SpaceH12(),

              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Router1.register,
                  );
                },
                child: buildSignUpText(
                    getTranslated(context, 'dontHaveAnAccount'), getTranslated(context, 'signUp'), context),
              ),

              // buildOtherLogins(context),
            ]));
  }
  Widget _buildPasswordField1() {
    return CustomInputField(
      label: getTranslated(context, 'password'),
      prefixIcon: Icons.lock,
      obscureText: hidePass,
      textColor: textColor,
      radiusColor: radiusColor,
      radius: radius1,
      type: TextInputType.text,
      textEditingController: passwordController,
      validator: (String? value) {
        return null;
      },
      onChanged: (val) {
        userModel.password = val;
      },
      onSaved: (String? value) {
        // _user.password = value;
      },
      trailing: trailing(),
    );
  }

  Widget _buildEmailField1() {
    return CustomInputField(
      label: getTranslated(context, 'email'),
      prefixIcon: Icons.email,
      obscureText: false,
      textColor: textColor,
      radiusColor: radiusColor,
      radius: radius1,
      onChanged: (val) {
        userModel.email = val;
      },
      onSaved: (String? value) {
        // _user.password = value;
      },
      type: TextInputType.emailAddress,
      textEditingController: emailController,
      validator: (String? value) {
        return null;
      },
    );
  }
  _buildFormFields() {
    return FadeTransition(
        opacity: animation!,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SpaceH60(),
              _buildEmailField1(),
              SpaceH24(),
              _buildPasswordField1(),
              SpaceH20(),
              SpaceH8(),

              Container(
              margin: EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: <Widget>[
                      Expanded(
                          child:  InkWell(
                              onTap: () {
                                setState(() {
                                  checkValidation = !checkValidation;
                                });
                                //  insertNewPlan();
                              },
                              child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: <Widget>[
                                    InkWell(
                                      // onTap: () {
                                      //   setState(() {
                                      //     checkValidation = !checkValidation;
                                      //   });
                                      //   //  insertNewPlan();
                                      // },
                                      child: Icon(
                                        checkValidation
                                            ? Icons.check_box_rounded
                                            : Icons.check_box_outline_blank,
                                        color: checkValidation
                                            ? AppColors.primary
                                            : AppColors.black.withOpacity(.6),
                                        size: 20,
                                      ),
                                    ),
                                    SpaceW8(),

                                    Expanded(
                                        child: Text(
                                          getTranslated(context, 'remindMe'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.0,
                                              color: AppColors.black.withOpacity(.7)),
                                        )),

                                     //Icon(
                                      // Icons.security,
                                       //size: 30,
                                       //color: AppColors.primary,
                                    //)
                                  ]))),
                      Expanded(
                          child:  Container(
                            // color: AppColors.pendingTask,
                              )),
                      Container(
                        // color: AppColors.pendingTask,
                          child: Text(
                            getTranslated(context, 'forgotPassword'),
                            style: TextStyle(color: AppColors.allLabel.withOpacity(.7)),
                          ))
                    ]),
              )
            ]));
  }

  Widget trailing() {
    return IconButton(
        icon: Icon(
          iconPass,
          color: textColor,
        ),
        onPressed: () {
          setState(() {
            hidePass = !hidePass;
            iconPass = hidePass ? Icons.visibility : Icons.visibility_off;
          });
        });
  }

  _buildAuthNavigation() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Login/Sign up',
        textAlign: TextAlign.left,
        style: TextStyle(color: AppColors.black.withOpacity(.9),
          fontSize: 24,
        ),
      ),
    );
  }



  _buildFormButton() {
    double buttonWidth = 80;
    return AnimatedBuilder(
        animation: _buttonSlideAnimation,
        builder: (context, child) {
          return Transform(
              transform: Matrix4.translationValues(
                  _buttonSlideAnimation.value * 180.0, 0, 0),
              child: Container(
                child: CustomButton(
                  color: AppColors.primary,
                  borderColor: AppColors.primary,
                  textColor: AppColors.white,
                  text: getTranslated(context, 'logIn'),
                  onPressed: () async {
                    _loginFunction();
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),);
        });
  }

  double _degreesToRadian(double degrees) {
    return degrees * math.pi / 180;
  }
}
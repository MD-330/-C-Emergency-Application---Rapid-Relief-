import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:Emergency/util/global_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
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
import '../widget/global_wedgit.dart';
import '../widget/login_widget.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  bool _isObsecure = true;
  final phoneFocusNode = FocusNode();
  final specializationFocusNode = FocusNode();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final _confirmPasswordController = TextEditingController();
  final descFocusNode = FocusNode();

  XFile? _userImageFile;
  ImageProvider? profileImage;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  UserModel userModel = UserModel();

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

  Color labelColor = AppColors.primary;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  void _signUpFunction() async {                                                // sing up in function
    FocusScope.of(context).unfocus();
    if ((userModel.username == '' || userModel.password == '' || userModel.phone == '' || userModel.email == '')) {
      GradientSnackBar.showError(context, "fields cannot be empty");
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
      userModel.setId = 'user';
      final storage = FirebaseStorage.instance;
      await Provider.of<AuthenticationController>(context, listen: false).signUp(userModel.email!, userModel.password!); //sign up
      if (globalUserId != null && globalUserId != '') {
        if (_userImageFile != null) {
          final ref = await storage.ref().child('user_images').child('$globalUserId.jpg');
          await ref.putFile(File(_userImageFile!.path));
          final imageUrl = await ref.getDownloadURL();
          userModel.photoUrl = imageUrl;
        } else
          userModel.photoUrl = GlobalData.globalProfile;
        userModel.uid = globalUserId;
        if (kDebugMode) {
          print(userModel.photoUrl);
        }
        await Provider.of<UserDataController>(context, listen: false).registerUser(userModel).then((value) =>
            Navigator.of(context).pushReplacementNamed(
                globalUserId != null && globalUserId != '' ? Router1.Splash : ''));
      }
    } on HttpException catch (error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, "Error creating the account");
      return;
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, "Error creating the account");
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    userModel.username = '';
    userModel.email = '';
    userModel.password = '';
    userModel.phone = '';
    userModel.photoUrl = '';
    userModel.setId = 'user';
    super.initState();
    curvedBackgroundLeftPosition = (math.sqrt(math.pow(100, 2) + math.pow(100, 2))) - curvedBackgroundRadius;
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _formController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _formButtonController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _logoSlideAnimation = Tween<double>(begin: -1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _logoController, curve: Interval(0, 1.0, curve: Curves.easeIn)));
    animation = CurvedAnimation(parent: _formController, curve: Curves.easeIn);

    _buttonSlideAnimation = Tween<double>(begin: 2.2, end: 0.0)
        .animate(CurvedAnimation(parent: _formButtonController, curve: Interval(0, 1.0, curve: Curves.easeIn)));
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

  void pickImage() async {
    print('pressed');
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image?.path == null) {
      GradientSnackBar.showError(context, "Please select image");
    }
    setState(() {
      _userImageFile = image;
      profileImage = FileImage(File(_userImageFile!.path));
      // _pickedImage = image;
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
      curvedBackgroundTopPosition = MediaQuery.of(context).size.height * .15;
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
                  _curvedBackContainer(AppColors.primary3.withOpacity(.8), curvedBackgroundTopPosition - 13,
                      curvedBackgroundLeftPosition - 2),
                  _curvedBackContainer(AppColors.white, curvedBackgroundTopPosition, curvedBackgroundLeftPosition),
                  _backgroundContainer(),
                  _buildTopPolygon(),
                  _buildLogoText(),
                  Container(
                    padding: EdgeInsets.only(top: size.height * .23, left: 15, right: 15),
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
        top: 12 / 100 * topPolygonSize,
        right: 12 / 100 * topPolygonSize,
        child: AnimatedBuilder(
            animation: _logoSlideAnimation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(0, _logoSlideAnimation.value * 100, 0),
                child: Container(
                    width: 120,
                    height: 120,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        backgroundColor: AppColors.grey.withOpacity(.1),
                        foregroundColor: AppColors.primary,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.camera,
                              color: AppColors.primary,
                              size: 25,
                            ),
                          ],
                        ),
                        backgroundImage: profileImage,
                        radius: 60,
                      ),
                    )),
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
                borderRadius: BorderRadius.all(Radius.circular(curvedBackgroundRadius)),
                color: color,
              ),
              width: deviceWidth / math.cos(_degreesToRadian(curvedBackgroundAngle)),
              //width:  MediaQuery.of(context).size.width,
              height: math.sqrt(math.pow(deviceWidth, 2) + math.pow(deviceWidth, 2)),
            )));
  }

  _backgroundContainer() {
    double deviceWidth = MediaQuery.of(context).size.width;
    double backgroundTopMargin =
        curvedBackgroundTopPosition + (deviceWidth * math.tan(_degreesToRadian(curvedBackgroundAngle)));
    return Padding(
        padding: EdgeInsets.only(top: backgroundTopMargin),
        child: Container(
          color: AppColors.white,
        ));
  }

  _buildFormContent() {
    return Container(
        height: MediaQuery.of(context).size.height * .8,
        child: SingleChildScrollView(
            child:
                Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                width: MediaQuery.of(context).size.width, alignment: Alignment.centerRight, child: _buildFormButton()),
          SpaceH20(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Router1.login,
              );
            },
            child:
                buildSignUpText(getTranslated(context, 'alreadyHaveAccount'), getTranslated(context, 'logIn'), context),
          ),
          SpaceH30(),
        ])));
  }

  _buildFormFields() {
    return FadeTransition(
        opacity: animation!,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SpaceH60(),
              CustomTextInput(
                isObsecure: false,
                autofocus: false,
                keyboardType: TextInputType.text,
                labelText: getTranslated(context, 'userName'),
                hintText: getTranslated(context, 'name_hint'),
                icon: Icons.person,
                nextFocusNode: phoneFocusNode,
                onChanged: (val) {
                  userModel.username = val;
                },
                label: labelInput(Icons.person, getTranslated(context, 'userName')),
              ),
              SpaceH16(),
              CustomTextInput(
                isObsecure: false,
                autofocus: false,
                keyboardType: TextInputType.phone,
                labelText: getTranslated(context, 'phoneNumber'),
                hintText: getTranslated(context, 'enterPhoneNumber'),
                icon: Icons.phone,
                nextFocusNode: emailFocusNode,
                onChanged: (val) {
                  userModel.phone = val;
                },
                label: labelInput(Icons.phone, getTranslated(context, 'phoneNumber')),
                focusNode: phoneFocusNode,
              ),
              SpaceH16(),
              CustomTextInput(
                isObsecure: false,
                keyboardType: TextInputType.emailAddress,
                labelText: getTranslated(context, 'email'),
                hintText: getTranslated(context, 'email_hint'),
                icon: Icons.email,
                onChanged: (val) {
                  userModel.email = val;
                },
                label: labelInput(Icons.email, getTranslated(context, 'email')),
                nextFocusNode: passwordFocusNode,
                focusNode: emailFocusNode,
              ),
              SpaceH16(),
              CustomTextInput(
                isObsecure: _isObsecure,
                keyboardType: TextInputType.text,
                labelText: getTranslated(context, 'password'),
                hintText: getTranslated(context, 'hintPassword'),
                icon: Icons.lock,
                onChanged: (val) {
                  userModel.password = val;
                },
                label: labelInput(Icons.lock, getTranslated(context, 'password')),
                suffixIcon: checkSecureText(),
                // nextFocusNode: confirmPasswordFocusNode,
                focusNode: passwordFocusNode,
              ),
              SpaceH30(),
            ]));
  }

  Widget checkSecureText() {
    return IconButton(
        icon: Icon(_isObsecure ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _isObsecure = !_isObsecure;
          });
        });
  }

  Widget labelInput(IconData? icon, String? labelText) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          textStyle: TextStyle(
            color: AppColors.allLabel,
            fontSize: 30,
            // fontWeight: FontWeight.bold
          )),
      onPressed: () {},
      icon: Icon(
        icon,
        size: 24.0,
        color: AppColors.allLabel,
      ),
      label: Text(
        labelText!,
        style: TextStyle(
          color: AppColors.allLabel,
          fontSize: 15,
        ),
      ),
    );
  }

  _buildAuthNavigation() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Sign up/Login',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColors.black.withOpacity(.9),
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
            transform: Matrix4.translationValues(_buttonSlideAnimation.value * 180.0, 0, 0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: CustomButton(
                color: AppColors.primary,
                borderColor: AppColors.primary,
                textColor: AppColors.white,
                text: getTranslated(context, 'signUp'),
                onPressed: () async {
                  _signUpFunction();
                },
              ),
            ),
          );
        });
  }

  _buildFormButton1() {
    double buttonWidth = 80;
    return AnimatedBuilder(
        animation: _buttonSlideAnimation,
        builder: (context, child) {
          return Transform(
              transform: Matrix4.translationValues(_buttonSlideAnimation.value * 100.0, 0, 0),
              child: InkWell(
                  // onTap: () async {
                  //   await _submitForm(context);
                  // },
                  child: Container(
                      height: buttonWidth,
                      width: buttonWidth,
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: FloatingActionButton(
                            backgroundColor: AppColors.primary3,
                            shape: const PolygonBorder(
                              sides: 6,
                              borderRadius: 10.0,
                            ),
                            child: Icon(Icons.arrow_forward),
                            onPressed: () async {
                              _signUpFunction();
                            },
                          )))));
        });
  }

  double _degreesToRadian(double degrees) {
    return degrees * math.pi / 180;
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20.0;

    final path = Path();
    path.lineTo(size.width / 2.0, 0.0);
    path.lineTo(0.0, size.height / 2.0);

    // path.quadraticBezierTo(0, size.height, factor, size.height);
    path.lineTo(size.width / 2.0, size.height);
    path.lineTo(size.width, size.height / 2.0);
    path.lineTo(size.width / 2.0, 0.0);
    // path.arcToPoint(Offset(radius, 0), radius: Radius.elliptical(40, 20));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

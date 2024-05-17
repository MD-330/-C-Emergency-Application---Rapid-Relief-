
import 'package:Emergency/util/global_data.dart';
import 'package:Emergency/values/spaces.dart';
import 'package:flutter/material.dart';
import 'package:Emergency/values/colors.dart';
List<String> loginPageImages = [
  "assets/Images/RectTopBlue.png",
  "assets/Images/RectTopBlue50.png",
  "assets/Images/RectBtmBlue.png",
  "assets/Images/RectBtmBlue50.png",
  "assets/Images/Logo1.png",
  "assets/Images/FacebookLogo.png",
  "assets/Images/GoogleLogo.png",
  "assets/Images/AppleLogo.png",
];
Widget buildTopClippers(double height) => Container(
      height: height,
      child: Stack(
        children: [
          buildTopClip1( AppColors.primary.withOpacity(.4),-330, -150, 1),
          buildTopClip1( AppColors.primary.withOpacity(1),-345, -150, 0),
        ],
      ),
    );

Widget buildTopClip1(Color color ,double myright, double mytop, int imageIndex) =>
    Positioned(
      right: myright,
      top: mytop,
      child: Container(
        width: 600,
        height: 350,
        child: Image.asset(
          loginPageImages[imageIndex],
          fit: BoxFit.contain,
          color: color,
        ),
      ),
    );
Widget buildLoginContainer(BuildContext context,String title) => Container(
  width: MediaQuery.of(context).size.width,
  height: 65,
  child: Stack(
    children: [
      buildLoginBtn(title),
    ],
  ),
);

Widget buildLoginBtn(String title) => Positioned(
  right: 0,
  child: Container(
    alignment: Alignment.center,
    width: 200,
    height: 55,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(0),
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(0),
      ),
      // color: Color.fromRGBO(11, 94, 255, 1),

      color: AppColors.primary,
    ),
    child: Row(
      mainAxisAlignment : MainAxisAlignment.center,
      children: [
        // widthSpacer(75.00),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18.00),
        ),
        widthSpacer(5.5),
        Icon(
          Icons.navigate_next,
          color: Colors.white,
        )
      ],
    ),
  ),
);

Widget buildLoginText() => Row(
  children: [
    widthSpacer(75.00),
    Text(
      "Login",
      style: TextStyle(color: Colors.white, fontSize: 20.00),
    ),
    widthSpacer(5.5),
    Icon(
      Icons.navigate_next,
      color: Colors.white,
    )
  ],
);
Widget buildOtherLogins(BuildContext context) {
  return Container(
    // color: AppColors.red,
    width: MediaQuery.of(context).size.width*.6,
    height: 60,
    child: Column(
      children: [
        buildOtherLoginText(),
        SpaceH8(),
        buildOtherLogo(),
      ],
    ),
  );}

Widget buildOtherLoginText() =>
    Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildDivider(),
      widthSpacer(5.5),
      Text(
        "or continue with",
        style: TextStyle(color: Colors.grey, fontSize: 15.00),
      ),
      widthSpacer(5.5),
      buildDivider(),
    ],
  ),
);
Widget buildOtherLogo() =>
    Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildLogo(5),
      widthSpacer(15.00),
      buildLogo(6),
      widthSpacer(15.00),
      buildLogo(7),
    ],
  ),
);

Widget buildDivider() => Container(
  color: Colors.grey,
  height: 1.2,
  width: 35,
);


Widget buildLogo(int imageIndex) => Container(
  width: 30,
  height: 30,
  child: Image.asset(
    loginPageImages[imageIndex],
    fit: BoxFit.contain,
  ),
);

Widget buildLogoField() => Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildLogoImage(4),
      widthSpacer(10.00),
      // Text('Training Companies',
      //   style: TextStyle(
      //       fontSize: 22,
      //       fontFamily: 'Aller',
      //       color: AppColors. primary12,
      //       fontWeight: FontWeight.bold),),
      buildLogoText("Training Companies")
    ],
  ),
);
Widget buildLogoImage(int imageIndex) => Container(
  width: 90,
  height: 90,
  child: Image.asset(
    GlobalData.logo,
    fit: BoxFit.cover,
  ),
);
Widget buildLogoText(String logoText) => Text(
  logoText,
  style: TextStyle(fontSize: 25.00,fontWeight: FontWeight.w500),
);
Widget buildBottomClippers1(BuildContext context) => Container(
  // color: AppColors.redDark,
  height: 200,
  child: Stack(
    children: [

      buildBottomClip(context,AppColors.primary.withOpacity(.3),-90, -72, 3),
      buildBottomClip(context,AppColors.primary,-90, -93, 2),
    ],
  ),
);

Widget buildBottomClip(BuildContext context,Color color,double myleft, double mybottom, int imageIndex) {
  return Positioned(
    left: myleft,
    right: -2,
    bottom: mybottom,
    child: Container(
      // color: AppColors.redDark,
      // margin: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      // width: 600,
      // height: 350,
      child: Image.asset(
        loginPageImages[imageIndex],
        fit: BoxFit.cover,
        color: color,
      ),
    ),
  );}
Widget buildBottomClippers() => Container(
  height: 200,
  child: Stack(
    children: [

      buildBottomClip1(AppColors.primary.withOpacity(.3),-180, -125, 3),
      buildBottomClip1(AppColors.primary,-180, -145, 2),
    ],
  ),
);
Widget buildBottomClip1(Color color,double myleft, double mybottom, int imageIndex) {
   return Positioned(
      left: myleft,
      bottom: mybottom,
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 20),
        width: 600,
        height: 350,
        child: Image.asset(
          loginPageImages[imageIndex],
          fit: BoxFit.contain,
          color: color,
        ),
      ),
    );}
Widget buildSignUpText(String text1,String text2,BuildContext context) => RichText(
  text: TextSpan(
    text: text1,
    style: TextStyle(color: Colors.grey, fontSize: 15.00),
    children: <TextSpan>[
      TextSpan(text: text2, style: TextStyle(color: Colors.blue)),
    ],
  ),
);
Widget buildTextField(String myhintText, IconData myIcons, bool canObscure,TextInputType? keyboardType,Widget? suffixIcon,ValueChanged<String>? onChanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.00),
      child: TextFormField(
        style: TextStyle(color: Colors.black.withOpacity(.7)),
        obscureText: canObscure,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(40.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(40.0),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: Icon(myIcons, color: Colors.black.withOpacity(.6)),
          hintText: myhintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),
          filled: true,

          fillColor: AppColors.black.withOpacity(.05),
        ),
      ),
    );
Widget heightSpacer(double myHeight) => SizedBox(height: myHeight);

Widget widthSpacer(double myWidth) => SizedBox(width: myWidth);

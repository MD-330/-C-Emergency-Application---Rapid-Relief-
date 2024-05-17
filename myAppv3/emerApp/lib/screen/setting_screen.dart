import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Emergency/api/database.dart';
import 'package:Emergency/screen/splash_screen.dart';
import 'package:Emergency/util/global_data.dart';
import '../api/authController.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../util/language_constants.dart';
import '../util/sharedPref.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/global_wedgit.dart';
import '../widget/setting_item.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'home_screen_admin.dart';

class SettingScreen2 extends StatefulWidget {
  @override
  _SettingScreen2State createState() => _SettingScreen2State();
}

class _SettingScreen2State extends State<SettingScreen2> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  late String selectLanguage;
  late File profileImageFile;
  late ImageProvider profileImage1;
  ImageProvider profileImage = Image.asset(
    'assets/user.png',
    color: AppColors.primary1,
  ).image;


  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    App.setLocale(context, _locale);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectLanguage = 'english';

    profileImage = CachedNetworkImageProvider(GlobalData.currentUser.photoUrl!);
  }

  Future pickImage() async {
    // profileImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    // if (profileImageFile != null && profileImageFile.path != null)
    //   configBloc.add(UpdateProfilePicture(profileImageFile));
    // else
    //   print('nooooooooooooooooooooooooooooooooooooooooooooooo');
  }

  Widget getTitleSetting(String txt) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                getTranslated(context, txt),

                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.black.withOpacity(.7)),
              ),
            ),
          ],
        ));
  }
  Future<bool> _onBackPressed() async {
    final shouldPop = await  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>GlobalData.currentUser.setId=='user'? HomeScreen(initialIndex: 0,):HomeScreenAdmin(), // Destination
      ),
          (route) => false,
    );
    return shouldPop ?? false;
  }
  Widget appBar() {
    return SizedBox(
      height: 85,
      child: Container(
        padding: EdgeInsets.only(top: 25, bottom: 5),
        margin: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(color: AppColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: InkWell(
                  onTap: () {
                    // Navigator.push<void>(
                    //     context,
                    //     MaterialPageRoute<void>(
                    //         builder: (context) =>
                    //             HomeScreen()));
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 30,
                  ),
                )),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    getTranslated(context, 'settings'),

                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.settings_applications,
                    color: AppColors.white,
                    size: 30,
                  ),
                  onTap: () {
                    //goBack();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              appBar(),
              SpaceH8(),

              SettingItem(
                color: AppColors.primary,
                icon: Icons.person_pin_outlined,
                txt: 'profile',
                checkText: true,
                leftWidget: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.black,
                  size: 15,
                ),
                onTap: () {},
              ),
              ProfileWidget1(context),
              Expanded(
                  child: Container(
//              width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height ,
                color: AppColors.whiteShade1,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  getTitleSetting('common'),
                  SettingItem(
                    color: AppColors.deepOrange,
                    icon: Icons.language,
                    txt: 'language',
                    checkText: true,
                    leftWidget: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.black,
                      size: 15,
                    ),
                    onTap: () {
                      _showPopupMenu();
                    },
                  ),
                  SettingItem(
                    color: AppColors.black,
                    icon: Icons.wb_sunny,
                    txt: 'darkMode',
                    checkText: true,
                    leftWidget: Switch(
                      value: false,
                      onChanged: null,
                    ),
                    onTap: () {},
                  ),
                  getTitleSetting(
                    'account',
                  ),
                  // SettingItem(
                  //   color: AppColors.primary,
                  //   icon: Icons.phone,
                  //   txt: '+96645872632',
                  //   leftWidget: Icon(
                  //     Icons.arrow_forward_ios,
                  //     color: AppColors.black,
                  //     size: 15,
                  //   ),
                  //   onTap: () {},
                  // ),
                  SettingItem(
                    color: AppColors.nearlyBlue,
                    icon: Icons.email,
                    txt: GlobalData.currentUser.email!,
                    leftWidget: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.black,
                      size: 15,
                    ),
                    onTap: () {},
                  ),
                  SettingItem(
                    color: AppColors.pink,
                    icon: Icons.lock,
                    txt: 'Change Password',
                    leftWidget: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.black,
                      size: 15,
                    ),
                    onTap: () {},
                  ),
                  getTitleSetting('security'),
                  SettingItem(
                    color: AppColors.primary,
                    icon: Icons.phonelink_lock,
                    txt: 'Lock app in background',
                    leftWidget: Switch(
                      value: false,
                      onChanged: null,
                    ),
                    onTap: () {},
                  ),
                  SettingItem(
                    color: AppColors.primary,
                    icon: Icons.notifications_active,
                    txt: 'Notification',
                    // checkText: true,
                    leftWidget: Switch(
                      value: false,
                      onChanged: null,
                    ),
                    onTap: () {},
                  ),
                  getTitleSetting(
                    'account',
                  ),
                  SettingItem(
                    color: AppColors.redDark,
                    icon: Icons.exit_to_app,
                    txt: 'logout',
                    checkText: true,
                    leftWidget: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.black,
                      size: 15,
                    ),
                    onTap: () {
                      showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('logout'),
                            content: Text('Do you want to log out of the app'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<AuthenticationController>(context,
                                          listen: false)
                                      .logout();
                                  FirebaseAuth.instance.signOut().then((value) {
                                    Navigator.pushAndRemoveUntil<void>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SplashScreen()),
                                      (Route<dynamic> route) => false,
                                    );
                                  });
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ])),
              ))
            ],
          ),
        )));
  }

  Widget ProfileWidget1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //border: Border.all(color: AppColors.primary, width: 0),
        borderRadius: const BorderRadius.all(Radius.circular(0.0)),
        color: AppColors.primary,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.grey.withOpacity(0.4),
            offset: const Offset(2, 2),
            blurRadius: 7,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                color: AppColors.white,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: CachedNetworkImage(
                    imageUrl: GlobalData.currentUser.photoUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     //border: Border.all(color: AppColors.primary, width: 0),
            //     borderRadius: const BorderRadius.all(Radius.circular(90.0)),
            //     color: AppColors.white,
            //     boxShadow: <BoxShadow>[
            //       BoxShadow(
            //         color: AppColors.grey.withOpacity(0.4),
            //         offset: const Offset(1, 4),
            //         blurRadius: 8,
            //       ),
            //     ],
            //   ),
            //   height: 70,
            //   width: 70,
            //   child: CircleAvatar(
            //
            //     backgroundColor: AppColors.white,
            //     radius: 90,
            //     child: Container(
            //       height: 70,
            //       width: 70,
            //
            //     ),
            //     backgroundImage: profileImage,
            //   ),
            //
            //   padding: const EdgeInsets.all(.5),
            //   // borde width
            // ),
            SpaceW12(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    GlobalData.currentUser.username!.toUpperCase(),
                    style: TextStyle(
                        fontSize: 18.0, color: AppColors.white.withOpacity(.9)),
                  ),
                  SpaceH4(),
                  Text(
                    GlobalData.currentUser.email!,
                    style: new TextStyle(
                        fontSize: 14.0, color: AppColors.white.withOpacity(.6)),
                  )
                ],
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(right: 1.0),
                child: Icon(
                  Icons.person_pin_outlined,
                  size: 28,
                  color: AppColors.white.withOpacity(.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIcon(IconData icon, Color color) {
    return Container(
        // margin: EdgeInsets.only(top: 5,bottom: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          color: color,
        ),
        child: Icon(
          icon,
          color: AppColors.white,
        ));
  }

  void _showPopupMenu() {
    showMenu<Language>(
      context: context,
      position: RelativeRect.fromLTRB(45.0, 45.0, 0.0, 0.0),
      //position where you want to show the menu on screen
      items: Language.languageList()
          .map<PopupMenuItem<Language>>(
            (e) => PopupMenuItem<Language>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    e.flag,
                    style: TextStyle(fontSize: 22),
                  ),
                  Container(
                    width: 100,
                    child: Text(e.name, style: TextStyle(fontSize: 12)),
                  ),

                ],
              ),
            ),
          )
          .toList(),
      elevation: 8.0,
    ).then<void>((Language? language) {
      if (language == null)
        return;
      else
        _changeLanguage(language);
    });
  }
}

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(2, "🇺🇸", "English", "en"),
      Language(3, "🇸🇦", "اَلْعَرَبِيَّةُ", "ar"),
    ];
  }
}

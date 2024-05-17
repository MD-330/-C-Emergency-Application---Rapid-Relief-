import 'package:Emergency/screen/services_screen.dart';
import 'package:Emergency/screen/setting_screen.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/reports.dart';
import '../model/services.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../values/spaces.dart';
import '../widget/global_wedgit.dart';
import '../widget/search_widget.dart';
import '../widget/water_effect.dart';
import 'add_report_screen.dart';
import 'requests/myreports_screen.dart';
import 'sub_services.dart';

class HomeScreen extends StatefulWidget {
  int initialIndex;

  HomeScreen({required this.initialIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool multiple = true;
  double iconSize = 25.0;
  int currentIndex = 0;

  void _updateIndex(int value) {
    setState(() {
      currentIndex = value;
    });
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  getLocation() async {
    if (GlobalData.reportAddress.isEmpty) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        GlobalData.reportAddress = position.latitude.toString() + '&' + position.longitude.toString();
      });
      print('*************************8');
      print(GlobalData.reportAddress);
      print('*************************8');
    } else {
      setState(() {
        // latitude = getLatitude(GlobalData.reportAddress);
        // longitude = getLongitude(GlobalData.reportAddress);
        print('########################');
        print(GlobalData.reportAddress);
        print('########################');
      });
    }
  }

  Future getCurrentLocation() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      if (!await Permission.location.request().isGranted) {
        print('no storage permission to use location');
        return;
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }
  }

  @override
  void initState() {
    // print('######################################3');
    // print(getTranslated(context, 'completed'));
    // print('######################################3');
    _updateIndex(widget.initialIndex);
    getCurrentLocation();

    super.initState();
  }


  Widget getServices(String title, List<Services> list) {
    return InkWell(
        onTap: () {
          GlobalData.cateName = title;
          Reports.reportInfo.reportName = title;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubServicesScreen(
                        servList: list,
                      )));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: AppColors.black.withOpacity(.1), width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  child: Image.asset(
                    'assets/cate/$title.png',
                    fit: BoxFit.contain,
                    height: 50,
                  ),
                ),
              ),
              SpaceH4(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                    child: Text(
                      getTranslated(context, title),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          color: AppColors.black.withOpacity(.6),
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          fontSize: 12),
                    ),
                  )
                ]),
              )
            ],
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(getTranslated(context, 'exitApp')),
            content: Text(getTranslated(context, 'checkExitApp')),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(getTranslated(context, 'no')),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(getTranslated(context, 'yes')),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget homeScreen() {
    // Color headerColor=AppColors.white;
    // Color headerTextColor=AppColors.black;
    // Color headerIconColor=AppColors.primary;
    // Color cardColor=AppColors.primary;
    // Color cardTextColor=AppColors.white;
    // Color btnColor=AppColors.primary0;

    Color headerColor = AppColors.primary;
    Color headerTextColor = AppColors.white;
    Color headerIconColor = AppColors.white;
    Color cardColor = AppColors.white;
    Color cardTextColor = AppColors.allLabel;
    Color btnColor = AppColors.iconColor.withOpacity(.9);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 40, right: 30, left: 30, bottom: 15),
                  height: 170,
                  decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppColors.grey.withOpacity(0.2), offset: const Offset(1.0, 2.0), blurRadius: 2),
                      ],
                      border: Border.all(color: AppColors.black.withOpacity(.3), width: 1)),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            getTranslated(context, 'welcome'),
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18, color: headerTextColor.withOpacity(.9)),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(children: <Widget>[
                            Icon(Icons.location_on, color: headerIconColor),
                            Icon(Icons.keyboard_arrow_down, color: headerIconColor),
                          ]),
                        ),
                      ],
                    ),
                    SpaceH4(),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: getRowWidget(
                          Text(
                            getTranslated(context, 'welcomeHeader'),
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14, color: headerTextColor.withOpacity(.8)),
                          ),
                        )),
                      ],
                    ),
                  ])),
            ]),

            Positioned(
              left: 0,
              top: 120,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      border: Border.all(color: AppColors.black.withOpacity(.1), width: 1)),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  padding: const EdgeInsets.all(15),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            getTranslated(context, 'emergencyImprovement'),
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16, color: cardTextColor.withOpacity(1)),
                          ),
                        ),
                      ],
                    ),
                    SpaceH8(),
                    Container(
                      // height: 400,
                      // color: AppColors.black.withOpacity(.1),
                      alignment: Alignment.topLeft,
                      child: Column(children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                                flex: 4,
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                    child: Image.asset(
                                      'assets/Images/22.png',
                                      fit: BoxFit.contain,
                                      color: AppColors.primary,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                )),
                            SpaceW24(),
                            Expanded(
                                flex: 7,
                                child: Container(
                                  // height: 400,
                                  // color: AppColors.black.withOpacity(.1),
                                  alignment: Alignment.topLeft,
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            getTranslated(context, 'reportAbout'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                height: 1.5,
                                                color: cardTextColor.withOpacity(.7)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SpaceH12(),
                                    InkWell(
                                      onTap: () {
                                        _updateIndex(1);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: btnColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                            border: Border.all(color: btnColor, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Center(
                                            child: Text(
                                              getTranslated(context, 'sendReport'),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: AppColors.white.withOpacity(1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                )),
                          ],
                        )
                      ]),
                    )
                  ])),
            ),
            Positioned(
                left: 0,
                top: 280,
                bottom: 0,
                right: 0,
                child: Container(
                    color: AppColors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      SpaceH20(),
                      SpaceH16(),
                      SpaceH16(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: getTitleWithIcon(getTranslated(context, 'services'), () {}, context),
                      ),
                      SpaceH16(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: getBackgroundContainer(),
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                    Text(
                                      getTranslated(context, 'important'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        letterSpacing: 0.27,
                                        color: AppColors.black.withOpacity(.7),
                                      ),
                                    ),
                                    SpaceH6(),
                                    Text(
                                      getTranslated(context, 'services'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: AppColors.black.withOpacity(.7),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                      child: Image.asset(
                                        GlobalData.logo,
                                        fit: BoxFit.contain,
                                        // width: 120,
                                        height: 100,
                                      ),
                                    ),
                                  ]))),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.allLabel.withOpacity(.5),
                              borderRadius: const BorderRadius.all(Radius.circular(26.0)),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 7),
                            height: 200,
                            width: 3,
                          ),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 1, right: 1),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: getServices('civilDefense', Services.civilDefense)),
                                      Expanded(child: getServices('ambulance', Services.ambulance)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 1, right: 1),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(flex: 2, child: Container()),
                                      Expanded(flex: 5, child: getServices('police', Services.police)),
                                      Expanded(flex: 2, child: Container()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                      SpaceH16(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: getBackgroundContainer(),
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  getTranslated(context, 'reports'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: AppColors.black.withOpacity(.8),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 0.0),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                  child: Image.asset(
                                    'assets/icons/serv6.png',
                                    fit: BoxFit.contain,
                                    // width: 60,
                                    height: 60,
                                    // color: AppColors.primary,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SpaceH6(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  getTranslated(context, 'reportDescription'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      height: 1.5,
                                      color: AppColors.black.withOpacity(.7)),
                                ),
                              ),
                            ],
                          ),
                          SpaceH8(),
                          Column(children: <Widget>[
                            getReportButton(
                              Icons.add_to_photos,
                              getTranslated(context, 'submitNewReport'),
                              () {
                                _updateIndex(1);
                              },
                            ),
                            getReportButton(Icons.assignment, getTranslated(context, 'ListRequest'), () {
                              _updateIndex(2);
                            }),
                          ])
                        ]),
                      ),
                      SpaceH16(),
                      SpaceH16(),
                    ]))))
          ],
        ));
  }
  Widget getReportButton(IconData icon, txt, GestureTapCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          // decoration: BoxDecoration(
          //     color: AppColors.primary,
          //     borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          //     border: Border.all(color: AppColors.primary, width: 2)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 28,
              ),
              SpaceW12(),
              Expanded(
                  child: Text(
                    txt,
                    style: TextStyle(color: AppColors.black.withOpacity(.6), fontWeight: FontWeight.bold, fontSize: 14),
                  )),
              Icon(
                Icons.arrow_forward_outlined,
                color: AppColors.black.withOpacity(.6),
                size: 20,
              ),
            ],
          ),
        ));
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return homeScreen(); // Create this function, it should return your first page as a widget
      case 1:
        return ServicesScreen(); // Create this function, it should return your second page as a widget
      case 2:
        return MyReportsScreen(); // Create this function, it should return your third page as a widget
      case 3:
        return SettingScreen2();
    }
    return Center(
      child: Text("There is no page builder for this index."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _getBody(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        iconSize: 30,
        onTap: _updateIndex,
        items: [
          BottomNavigationBarItem(
            label: getTranslated(context, "home"),
            icon: Icon(
              Icons.home,
              size: iconSize,
            ),
          ),
          BottomNavigationBarItem(
            label: getTranslated(context, "services"),
            icon: Icon(Icons.api, size: iconSize),
          ),
          BottomNavigationBarItem(
            label: getTranslated(context, "myReports"),
            icon: Icon(Icons.layers, size: iconSize),
          ),
          BottomNavigationBarItem(
            label: getTranslated(context, "settings"),
            icon: Icon(Icons.person_pin, size: iconSize),
          ),
        ],
      ),
    );
  }
}




import 'dart:async';

import 'package:Emergency/screen/requests/manage_reports_screen.dart';
import 'package:Emergency/values/colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/database.dart';
import '../model/reports.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../util/sharedPref.dart';
import '../widget/global_wedgit.dart';
import 'requests/reports_screen.dart';
import 'setting_screen.dart';


class HomeScreenAdmin extends StatefulWidget {
  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> with TickerProviderStateMixin {
  late SharedPreferences prefs;

  bool multiple = true;
  double iconSize = 25.0;
  int currentIndex = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  double myLatitude = 0.0;
  double myLongitude = 0.0;
  late SharedPref sharedPref;

  getReportLocation() async {
    sharedPref = SharedPref();
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("currentReport")) {
      GlobalData.currentReport =
          Reports.fromJson(await sharedPref.read("currentReport"));
      report = GlobalData.currentReport;
      if(GlobalData.currentReport.reportAddress!.isNotEmpty&&GlobalData.currentReport.reportAddress!.contains('&')){
        print('2');
        setState(() {
          latitude = getLatitude(GlobalData.currentReport.reportAddress!);
          longitude = getLongitude(GlobalData.currentReport.reportAddress!);
        });
        await getMyLocation();
      }
      else
        return;
    }
    else
      return;
    print('1');
  }

  void checkDistance() {
    print('*****************');
    distanceCalculation();
    Timer(
        Duration(seconds: 5),
            () =>  checkDistance()
    );


    // setState(() {});
    // Timer(Duration(seconds: 5), () => checkDistance());
  }
  double distanceInMeters = 0.0;
  double distanceInMetersCheck = 0.0;
  double distanceInKMeters = 0.0;
  late Reports report;
  Future saveResponseLocation(Reports report ) async {
    await DatabaseService(uid: '').editReport(report);
    sharedPref.save('currentReport', report.toMap());
  }
  void editResponseLocation(BuildContext context) async {
      try {
        await saveResponseLocation(report);
      } catch (error) {
        print(error);
      }
  }
  void distanceCalculation() async {
    if (mounted) {
      setState(() {
        distanceInMeters = Geolocator.distanceBetween(latitude, longitude, myLatitude, myLongitude);
        if (distanceInMeters > 30) {
          report.responseLocation = myLatitude.toString() + '&' + myLongitude.toString();
            editResponseLocation(context);
        } else {
          report.responseLocation = myLatitude.toString() + '&' + myLongitude.toString();
          report.accessTime=DateTime.tryParse(
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())).toString();
          editResponseLocation(context);
        }
      });
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  getMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      print('3');
      // // checkNoti
      // myLatitude = 21.43782112428314;
      // myLongitude =39.87642835497856;

      myLatitude = position.latitude;
      myLongitude = position.longitude;
      checkDistance();
    });
  }
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

  @override
  void initState() {
    getReportLocation();

    super.initState();
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return ManageReportsScreen(); // Create this function, it should return your first page as a widget
      case 1:
        return SettingScreen2(); // Create this function, it should return your second page as a widget
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
            label: getTranslated(context, "reportsList"),
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

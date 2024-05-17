


import 'package:Emergency/values/colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/language_constants.dart';
import 'requests/reports_screen.dart';
import 'setting_screen.dart';


class HomeScreenAdmin extends StatefulWidget {
  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> with TickerProviderStateMixin {
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

  @override
  void initState() {

    super.initState();
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return ReportsScreen(); // Create this function, it should return your first page as a widget
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

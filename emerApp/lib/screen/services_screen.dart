import 'package:Emergency/model/reports.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/services.dart';
import '../router.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../values/spaces.dart';
import '../widget/global_wedgit.dart';
import '../widget/search_widget.dart';
import 'add_report_screen.dart';
import 'home_screen.dart';
import 'sub_services.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Widget getServices(name, List<Services> list) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 7),
      decoration: getBackgroundContainer(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              GlobalData.cateName = name;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubServicesScreen(
                        servList: list,
                      )));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 1),
              // color: AppColors.red.withOpacity(.05),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                child: Image.asset(
                  'assets/cate/$name.png',
                  fit: BoxFit.contain,
                  // width: 100,
                  height: 120,
                ),
              ),
            ),
          ),
          SpaceH6(),
          Container(
            color: AppColors.primary.withOpacity(.1),
            padding: EdgeInsets.symmetric(vertical: 5),
            child:
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: Text(
                  getTranslated(context, name),
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
    );
  }
  Future<bool> _onBackPressed() async {
    final shouldPop = await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          initialIndex: 0,
        ), // Destination
      ),
      (route) => false,
    );
    return shouldPop ?? false;
  }

  Widget homeScreen() {
    return Stack(
      children: <Widget>[
        Column(children: <Widget>[
          Container(
              padding:
                  EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 15),
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.centerLeft,
                  begin: Alignment.centerRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary,
                    AppColors.primary.withOpacity(.9),
                    AppColors.primary.withOpacity(.8),
                    // AppColors.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                // boxShadow: <BoxShadow>[
                //   BoxShadow(
                //       color: AppColors.grey.withOpacity(0.2),
                //       offset: const Offset(1.0, 2.0),
                //       blurRadius: 5),
                // ],
              ),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        getTranslated(context, 'services'),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            height: 1.3,
                            color: AppColors.white.withOpacity(1)),
                      ),
                    ),
                  ],
                ),
                SpaceH4(),
              ])),
        ]),
        Positioned(
            left: 0,
            top: 85,
            right: 0,
            child: SearchWidget(
              onTap: () {},
            )),
        Positioned(
            left: 0,
            top: 150,
            bottom: 0,
            right: 0,
            child: Container(
                color: AppColors.transparent,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  SpaceH10(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 1),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: Row(
                            children: <Widget>[
                          Expanded(child:getServices(
                                  'civilDefense', Services.civilDefense)),
                  Expanded(child:getServices('ambulance', Services.ambulance)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: Row(
                            children: <Widget>[
                          Expanded(child: getServices('police', Services.police)),
                  Expanded(child:getServices('coastguard', Services.coastguard)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 1, right: 1),
                          child: Row(
                            children: <Widget>[
                              // getServices( 'police',Services.police),
                              Expanded(flex: 2, child: Container()),
                          Expanded(
                              flex: 5,
                              child:getServices('naturalDisasters',
                                  Services.naturalDisasters)),
                              Expanded(flex: 2, child: Container()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpaceH16(),
                ]))))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: homeScreen(),
        ));
  }
}

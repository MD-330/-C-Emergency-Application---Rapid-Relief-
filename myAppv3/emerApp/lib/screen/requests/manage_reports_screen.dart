// import 'package:Afforestation/CustomerHome/home_screen.dart';
import 'package:Emergency/screen/requests/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../api/database.dart';
import '../../model/reports.dart';
import '../../util/global_data.dart';
import '../../util/language_constants.dart';
import '../../values/colors.dart';
import '../../widget/global_wedgit.dart';
import '../home_screen.dart';
class ManageReportsScreen extends StatefulWidget {
  @override
  _ManageReportsScreenState createState() => _ManageReportsScreenState();
}

class _ManageReportsScreenState extends State<ManageReportsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
    child:Scaffold(
        backgroundColor: AppColors.whiteShade2,
        body: Container(
          child: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  // color: AppColors.white,
                  child: StreamProvider<List<Reports>>.value(
                    value: DatabaseService(uid: '').getReports(GlobalData.currentUser.setId),
                    initialData: [],
                    child: GetReports(),
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(.7),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(1, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40, left: 18, right: 18, bottom: 10),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) =>  HomeScreen(initialIndex: 0,)));
              },
              child: Icon(
              Icons.arrow_back_sharp,
              color: AppColors.black.withOpacity(.8),
              size: 25,
            ),),

//            Container(
//              alignment: Alignment.centerLeft,
//              width: AppBar().preferredSize.height + 40,
//              height: AppBar().preferredSize.height,
//            ),
            Expanded(
              child: Center(
                child: Text(
                  getTranslated(context, 'reportsList'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Container(
//              width: AppBar().preferredSize.height + 40,
//              height: AppBar().preferredSize.height,
              child: Row(
                children: [

                  SizedBox(width: 10),
                  CustomActionButton(
                    icon: GlobalData.filterStrokeSvg,
                    iconSize: 15,
                    color: AppColors.dark_900,
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ignore: must_be_immutable
class GetReports extends StatefulWidget {
  @override
  _GetReportsState createState() => _GetReportsState();
}

class _GetReportsState extends State<GetReports> {
  List<Reports> reportsList = [];
  List<Reports> pendingList = [];
  List<Reports> respondedList = [];
  List<Reports> completedList = [];

  List<Map>? tabList;
  bool isMapSelected = false;
  PageController? _pageController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    tabList = [
      {
        "title":  'pending',
        "isSelected": true,
      },
      {
        "title":  'responded',
        "isSelected": false,
      },
      {
        "title":  'completed',
        "isSelected": false,
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    completedList.clear();
    pendingList.clear();
    respondedList.clear();
    completedList.clear();

    setState(() {
      reportsList = Provider.of<List<Reports>>(context);
    });
    if (reportsList.length != 0) {
      setState(() {
        reportsList = Provider.of<List<Reports>>(context);
        for (var report in reportsList)
          if(report.reportStatus == 'pending')
            pendingList.add(report);
          else  if(report.reportStatus == 'responded')
            respondedList.add(report);
          else
            completedList.add(report);
      });
    }

    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 14),
        Container(
          height: 50,
          width: screenSize.width,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.light_500,
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: List.generate(
              tabList!.length,
              (index) {
                Map tab = tabList![index];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tabList!.forEach((element) {
                          element['isSelected'] = false;
                        });
                        tabList![index]['isSelected'] = true;
                        _pageController!.jumpToPage(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: tab['isSelected']
                            ? (AppColors.primary)
                            : AppColors.transparent,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context, tab['title']),
                        style: TextStyle(
                          color: tab['isSelected']
                              ? (AppColors.white)
                              : (AppColors.text_900),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
//              PassScreen(
//                isMapSelected: isMapSelected,
//                bookingList: _tasksList,
//              ),
              ReportCard(
                isMapSelected: isMapSelected,
                reportsList: pendingList,
              ),
              ReportCard(
                isMapSelected: isMapSelected,
                reportsList: respondedList,
              ),
              ReportCard(
                isMapSelected: isMapSelected,
                reportsList: completedList,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

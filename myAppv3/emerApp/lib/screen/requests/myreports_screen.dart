import 'package:Emergency/api/database.dart';
import 'package:Emergency/model/reports.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../util/global_data.dart';
import '../../util/language_constants.dart';
import '../../widget/global_wedgit.dart';
import '../home_screen.dart';
import 'myreport_card.dart';

class MyReportsScreen extends StatefulWidget {
  @override
  _MyReportsScreenState createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen>
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
  Future<bool> _onBackPressed() async {
    final shouldPop = await  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(initialIndex: 0,), // Destination
      ),
          (route) => false,
    );
    return shouldPop ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
    child:Scaffold(
        // backgroundColor: AppColors.whiteShade2,
        body: Container(
          child: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // color: AppColors.white,
                  child: StreamProvider<List<Reports>>.value(
                    value: DatabaseService(uid: '')
                        .getMyReports(GlobalData.currentUser.uid!),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 0,)));
              },
              child: Icon(
              Icons.arrow_back_sharp,
              color: AppColors.black.withOpacity(.8),
              size: 25,
            ),),

            Expanded(
              child: Center(
                child: Text(
                  getTranslated(context, 'myReports'),
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
                  CustomActionButton(
                    icon: GlobalData.mapStrokeSvg,
                    iconSize: 15,
                    color: AppColors.dark_900,
                    onTap: () {
                      setState(() {});
                    },
                  ),
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

  bool isMapSelected = false;
  PageController? _pageController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      reportsList = Provider.of<List<Reports>>(context);
      print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
      print(reportsList.length);
      print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    });


    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 14),
        Expanded(
          child:  MyReportCard(
            reportsList: reportsList,
          ),
        ),
      ],
    );
  }
}

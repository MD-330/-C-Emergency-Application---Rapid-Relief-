import 'package:Emergency/api/database.dart';
import 'package:Emergency/model/reports.dart';
import 'package:Emergency/screen/requests/report_card.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../util/global_data.dart';
import '../../util/language_constants.dart';
import '../../values/spaces.dart';
import '../../widget/global_wedgit.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with TickerProviderStateMixin {
  // ConfigBloc configBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // configBloc = BlocProvider.of<ConfigBloc>(context);


  }
  @override
  void initState() {
    super.initState();
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
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
        padding: EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 10),
        child: Row(
          children: <Widget>[
            SpaceW16(),
            InkWell(
              onTap: () {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return CheckDialog(
                //       title: getTranslated(context, 'signOut'),
                //       content: getTranslated(context, 'checkSignOut'),
                //       pressYes: () => {
                //         BlocProvider.of<AuthenticationBloc>(context)
                //             .add(ClickedLogout()),
                //         configBloc.add(RestartApp())
                //       },
                //       pressNo: () {
                //         Navigator.pop(context, true);
                //       },
                //     );
                //   },
                // );
              },
              child:Icon(
              Icons.exit_to_app,
              color: AppColors.black,
              size: 30,
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
    if(reportsList.length!=0){
      setState(() {
        reportsList = Provider.of<List<Reports>>(context);
      });
    }

    return Column(
      children: [
        SizedBox(height: 17),
        SizedBox(height: 10),
        Expanded(
          child: ReportCard(
            isMapSelected: isMapSelected,
            reportsList: reportsList,
          ),
        ),
      ],
    );
  }
}

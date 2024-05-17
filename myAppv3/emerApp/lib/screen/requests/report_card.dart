import 'package:Emergency/api/database.dart';
import 'package:Emergency/model/reports.dart';
import 'package:Emergency/model/user_model.dart';
import 'package:Emergency/values/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/global_data.dart';
import '../../util/language_constants.dart';
import '../../util/project_function.dart';
import '../../util/sharedPref.dart';
import '../../values/spaces.dart';
import '../../widget/GradientSnackBar.dart';
import '../../widget/global_wedgit.dart';
import '../show_report_screen.dart';
import '../track_location_screen.dart';

class ReportCard extends StatefulWidget {
  final bool isMapSelected;
  final List<Reports> reportsList;

  const ReportCard({Key? key, required this.isMapSelected, required this.reportsList}) : super(key: key);

  @override
  _ReportCardState createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  Widget getOpenTime(UserModel userInfo, Reports reportDetails) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              child: Row(children: <Widget>[
            Expanded(
                flex: 6,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Text(
                        getTranslated(context, 'reportAuthor'),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16.0, color: AppColors.black.withOpacity(.7)),
                      )),
                    ]))),
            SpaceW8(),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CheckDialog(
                      title: getTranslated(context, 'Cancel'),
                      content: getTranslated(context, 'cancelRequestCheck'),
                      pressYes: () async {
                        await DatabaseService(uid: '').cancelReport(reportDetails.reportId);
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                      pressNo: () {
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete_forever,
                color: AppColors.redDark.withOpacity(1),
                size: 25,
              ),
            ),
          ])),
          SpaceH8(),
          GestureDetector(
            child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.light_200,
                borderRadius: BorderRadius.circular(6),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: AppColors.grey.withOpacity(0.5), offset: const Offset(1.1, 1.1), blurRadius: 4.0),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // color: ColorUtilities.primary_050,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: userInfo.photoUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Row(children: <Widget>[
                          Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SpaceW4(),
                          Text(userInfo.username ?? '',
                              style: TextStyle(
                                color: AppColors.text_900,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              )),
                        ])),
                        SpaceH6(),
                        Container(
                            child: Row(children: <Widget>[
                          Icon(
                            Icons.email,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SpaceW4(),
                          Text(userInfo.email ?? '',
                              style: TextStyle(
                                color: AppColors.text_900,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              )),
                        ])),
                        SpaceH6(),
                        Container(
                            child: Row(children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SpaceW4(),
                          Text(userInfo.phone ?? '',
                              style: TextStyle(
                                color: AppColors.text_900,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              )),
                        ])),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SpaceH10(),
        ]);
  }

  void showOpenTime(UserModel userInfo, Reports booking, BuildContext context) {
    showBottomDialog(context: context, allowBackNavigation: true, contentWidget: getOpenTime(userInfo, booking));
  }

  dynamic dropdownSelectedValue;

  Widget getUser(Reports request, BuildContext context) {
    UserModel user;
    return request.userId!.isNotEmpty
        ? FutureBuilder<UserModel>(
            future: getUserInfo(request.userId),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("");
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text("");
                case ConnectionState.done:
                  if (snapshot.hasError) return Text("");
                  user = snapshot.data!;
                  return getReportInfo(user, request, context);
                //Text('Result: ${tasks.length} dk');
              }
            },
          )
        : Text(getTranslated(context, 'requestEmpty'));
  }

  Widget getReportInfo(UserModel userInfo, Reports reportDetails, BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.white,
          border: Border.all(
            color: AppColors.light_500,
          ),
        ),
        child: Column(children: <Widget>[
          Container(
              child: Row(children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Row(children: <Widget>[
                          Text(
                            getTranslated(context, 'emergencyIs'),
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12.0, color: AppColors.primary.withOpacity(.9)),
                          ),
                          SpaceW4(),
                          Expanded(
                            child: Text(
                              getTranslated(context, reportDetails.reportName!),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.black.withOpacity(.5)),
                            ),
                          ),
                        ]),
                      ),
                    ]))),
            InkWell(
              onTap: () {
                showOpenTime(userInfo, reportDetails, context);
              },
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.black.withOpacity(.5),
                size: 30,
              ),
            ),
            SpaceW8(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowReportScreen(
                              reportDetails1: reportDetails,
                            )));
              },
              child: Icon(
                Icons.info,
                color: AppColors.black.withOpacity(.5),
                size: 25,
              ),
            ),
                SpaceW8(),
            reportDetails.reportStatus == 'responded'
                ? InkWell(
                    onTap: () {
                      checkPermission(reportDetails);
                    },
                    child: Icon(
                      Icons.map_rounded,
                      color: AppColors.black.withOpacity(.5),
                      size: 25,
                    ),
                  )
                : SpaceW2(),
          ])),
          SpaceH4(),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowReportScreen(
                                  reportDetails1: reportDetails,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.light_700,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    // color: AppColors.red.withOpacity(.05),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                      child: Image.asset(
                        'assets/subCate/${reportDetails.reportName}.png',
                        fit: BoxFit.contain,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  )),
              Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(children: <Widget>[
                    SpaceH4(),
                    Container(
                        child: Row(children: <Widget>[
                      Icon(
                        Icons.category,
                        color: AppColors.black.withOpacity(.5),
                        size: 20,
                      ),
                      SpaceW4(),
                      Text(
                        getTranslated(context, reportDetails.cateName!),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13.0, color: AppColors.black.withOpacity(.7)),
                      )
                    ])),
                    SpaceH6(),
                    Container(
                        child: Row(children: <Widget>[
                      Container(
                          child: Row(children: <Widget>[
                        Icon(
                          Icons.confirmation_num_outlined,
                          color: AppColors.black.withOpacity(.5),
                          // size: 20,
                        ),
                        SpaceW4(),
                        Text(
                          reportDetails.reportNum!,
                          maxLines: 4,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.black.withOpacity(.7)),
                        )
                      ])),
                      SpaceW12(),
                      Expanded(
                        child: Container(
                            child: Row(children: <Widget>[
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.black.withOpacity(.5),
                            size: 20,
                          ),
                          SpaceW4(),
                          Expanded(
                              child: Text(
                            '${getTimeAgo(reportDetails.requestDate!)}',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.black.withOpacity(.7)),
                          ))
                        ])),
                      ),
                    ])),
                    SpaceH4(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                              Text(
                                getTranslated(context, 'status') + ": ",
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                  height: 1.3,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                              // Expanded(child:    ,),
                              Expanded(
                                child: GetStatus(status: reportDetails.reportStatus!),
                              ),
                            ]),
                          ),
                        ),
                        reportDetails.reportStatus == 'completed'
                            ? SpaceW4()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.9),
                                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (reportDetails.reportStatus == 'pending')
                                      permissionServiceCall(reportDetails);
                                    else
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CheckDialog(
                                            title: getTranslated(context, 'complete'),
                                            content: getTranslated(context, 'checkComplete'),
                                            pressYes: () async {
                                              final prefs = await SharedPreferences.getInstance();

                                              await DatabaseService(uid: '').completeReport(reportDetails.reportId);
                                              prefs.remove('currentReport');
                                              GlobalData.currentReport = new Reports();
                                              Navigator.pop(context, true);
                                            },
                                            pressNo: () {
                                              Navigator.pop(context, true);
                                            },
                                          );
                                        },
                                      );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.library_add_check_rounded,
                                          color: AppColors.white,
                                          size: 20,
                                        ),
                                        SpaceW4(),
                                        Text(
                                          getTranslated(context,
                                              reportDetails.reportStatus == 'pending' ? 'response' : 'complete'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            letterSpacing: 0.27,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                      ]),
                    ),
                  ]),
                ),
              ),
            ],
          )),
        ]));
  }

  void checkPermission(Reports reportDetails) async {
    SharedPref sharedPref = SharedPref();
    await permissionServices(reportDetails).then(
      (value) {
        if (value.isNotEmpty) {
          if (value[Permission.location]!.isGranted) {
            sharedPref.save('currentReport', reportDetails.toMap());
            GlobalData.currentReport = reportDetails;
            Navigator.push(context, MaterialPageRoute(builder: (_) => TrackLocationScreen()));
          }
        }
      },
    );
  }

  Future<Map<Permission, PermissionStatus>> permissionServices(Reports reportDetails) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    if (statuses[Permission.location]!.isPermanentlyDenied) {
      GradientSnackBar.showError(context, getTranslated(context, 'pleaseAllowPermission'));
      await Future.delayed(const Duration(seconds: 4));
      await openAppSettings().then(
        (value) async {
          if (value) {
            if (await Permission.location.status.isPermanentlyDenied == true &&
                await Permission.location.status.isGranted == false) {
              permissionServiceCall(reportDetails); /* opens app settings until permission is granted */
            }
          }
        },
      );
    } else {
      if (statuses[Permission.location]!.isDenied) {
        permissionServiceCall(reportDetails);
      }
    }
    return statuses;
  }

  void permissionServiceCall(Reports reportDetails) async {
    String responseTime = DateTime.tryParse(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())).toString();
    SharedPref sharedPref = SharedPref();
    await permissionServices(reportDetails).then(
      (value) {
        if (value.isNotEmpty) {
          if (value[Permission.location]!.isGranted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CheckDialog(
                  title: getTranslated(context, 'response'),
                  content: getTranslated(context, 'checkResponse'),
                  pressYes: () async {
                    await DatabaseService(uid: '').responseReport(reportDetails.reportId);
                    reportDetails.reportStatus = 'responded';
                    reportDetails.responseTime = responseTime;
                    sharedPref.save('currentReport', reportDetails.toMap());
                    GlobalData.currentReport = Reports.fromJson(await sharedPref.read("currentReport"));
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TrackLocationScreen()));
                  },
                  pressNo: () {
                    Navigator.pop(context, true);
                  },
                );
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: widget.reportsList.length == 0
          ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(15),
              child: Text(getTranslated(context, 'requestEmpty')))
          : Column(
              children: widget.reportsList.map((booking) {
                return getUser(booking, context);
              }).toList(),
            ),
    );
  }
}

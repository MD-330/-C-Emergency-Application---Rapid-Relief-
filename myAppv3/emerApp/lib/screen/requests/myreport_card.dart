import 'package:Emergency/api/database.dart';

import 'package:Emergency/model/reports.dart';
import 'package:Emergency/model/user_model.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/material.dart';

import '../../util/global_data.dart';
import '../../util/language_constants.dart';
import '../../util/project_function.dart';
import '../../values/spaces.dart';
import '../../widget/global_wedgit.dart';
import '../show_report_screen.dart';
import '../track_response_screen.dart';

class MyReportCard extends StatefulWidget {
  final List<Reports> reportsList;

  const MyReportCard({Key? key, required this.reportsList}) : super(key: key);

  @override
  _MyReportCardState createState() => _MyReportCardState();
}

class _MyReportCardState extends State<MyReportCard> {
  dynamic dropdownSelectedValue;

  Widget getUser(Reports booking, BuildContext context) {
    UserModel user;
    return booking.userId!.isNotEmpty
        ? FutureBuilder<UserModel>(
            future: getUserInfo(booking.userId),
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
                  return getReportInfo(user, booking, context);
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
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
          border: Border.all(
            color: AppColors.light_700,
          ),
        ),
        child: Column(children: <Widget>[
          Container(
              child: Row(children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(children: <Widget>[
                      Text(
                        getTranslated(context, 'emergencyIs'),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12.0, color: AppColors.black.withOpacity(.9)),
                      ),
                      SpaceW6(),
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
                          color: AppColors.black.withOpacity(.6),
                          size: 25,
                        ),
                      ),
                      SpaceW6(),
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
                                },
                                pressNo: () {
                                  Navigator.pop(context, true);
                                },
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.cancel,
                          color: AppColors.redDark.withOpacity(1),
                          size: 25,
                        ),
                      ),
                    ]))),
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
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(1),
              //     // color: ColorUtilities.primary_050,
              //   ),
              //   child: Icon(
              //     Icons.assignment,
              //     color: AppColors.primary,
              //     size: 70,
              //   ),
              // ),
              Expanded(
                flex: 8,
                child: Container(
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
                    SpaceH6(),
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
                        reportDetails.reportStatus != 'responded'
                            ? SpaceW4()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.9),
                                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (reportDetails.responseLocation!.isNotEmpty &&
                                        reportDetails.responseLocation!.contains('&')) {
                                      GlobalData.currentReport = reportDetails;
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (_) => TrackResponseScreen()));
                                    }
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
                                          getTranslated(context, 'tracking'),
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

import 'package:Emergency/api/database.dart';

import 'package:Emergency/model/reports.dart';
import 'package:Emergency/model/user_model.dart';
import 'package:Emergency/values/colors.dart';
import 'package:flutter/material.dart';

import '../../util/language_constants.dart';
import '../../util/project_function.dart';
import '../../values/spaces.dart';
import '../../widget/global_wedgit.dart';
import '../show_report_screen.dart';

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

  Widget getReportInfo(
      UserModel userInfo, Reports reportDetails, BuildContext context) {
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
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                            color: AppColors.black.withOpacity(.9)),
                      ),
                      SpaceW6(),
                      Expanded(
                        child: Text(
                          getTranslated(context, reportDetails.reportName!),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: AppColors.black.withOpacity(.5)),
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
                          Icons.app_registration,
                          color: AppColors.black.withOpacity(.6),
                          size: 25,
                        ),
                      ),
                    ]))),
            SpaceW12(),
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
                child:Container(
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
              ) ,)
              ,
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
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: AppColors.black.withOpacity(.7)),
                          )
                        ])),

                    SpaceH6(),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Container(
                              child: Row(children: <Widget>[
                            Icon(
                              Icons.confirmation_num_outlined,
                              color: AppColors.black.withOpacity(.6),
                              size: 20,
                            ),
                            SpaceW4(),
                            Text(
                              reportDetails.reportNum!,
                              maxLines: 4,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.0,
                                  color: AppColors.black.withOpacity(.7)),
                            )
                          ])),
                        ),
                        SpaceW8(),
                        Expanded(
                            flex: 4,
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CheckDialog(
                                        title: getTranslated(context, 'Cancel'),
                                        content: getTranslated(
                                            context, 'cancelRequestCheck'),
                                        pressYes: () async {
                                          await DatabaseService(uid: '')
                                              .cancelReport(
                                                  reportDetails.reportId);
                                          Navigator.pop(context, true);
                                        },
                                        pressNo: () {
                                          Navigator.pop(context, true);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.0)),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            getTranslated(context, 'Cancel'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: 0.0,
                                              color: AppColors.white
                                                  .withOpacity(0.9),
                                            ),
                                          ),
                                        ])))),
                      ],
                    )),
                    Container(
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.black.withOpacity(.5),
                            size: 20,
                          ),
                          SpaceW4(),
                          Text(
                            '${getTimeAgo(reportDetails.requestDate!)}',
                            maxLines: 4,
                            overflow: TextOverflow.clip,
                            softWrap: true,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0,
                                color: AppColors.black.withOpacity(.7)),
                          )
                        ])),
                    SpaceH4(),
                    SpaceH6(),
                  ]),
                ),
              ),
            ],
          )),
        ]));

    // return AppointmentListCard(
    //   title: beautician.username,
    //   address: beautician.address,
    //   date: booking.requestDate,
    //   service: booking.className,
    //   appointmentCardType: widget.isMapSelected
    //       ? AppointmentCardType.passMap
    //       : AppointmentCardType.pass,
    //   image: beautician.photoUrl,
    //   booking: booking,
    //   dropdownItems: [
    //     DropdownMenuItem(
    //       child: Text(
    //         '30 min before',
    //         style: TextStyle(
    //             color:  AppColors.text_900),
    //       ),
    //       value: 1,
    //     ),
    //     DropdownMenuItem(
    //       child: Text(
    //         '15 min before',
    //         style: TextStyle(
    //             color:  AppColors.text_900),
    //       ),
    //       value: 2,
    //     ),
    //   ],
    //   dropdownSelectedValue: dropdownSelectedValue,
    //   onChangeDropdownValue: (dynamic value) {
    //     setState(() {
    //       dropdownSelectedValue = value;
    //     });
    //   },
    //   onCancle: () {
    //     //Get.dialog(CanclePopup());
    //   },
    // );
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

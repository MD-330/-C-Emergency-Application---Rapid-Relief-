import 'dart:convert';


import '../util/global_data.dart';

class Reports {
  String? reportId;
  String? reportNum;
  String? cateName;
  String? userId;
  String? reportName;
  String? reportDesc;
  String? reportAddress;
  DateTime? requestDate;
  String? reportStatus;
  String? responseLocation;
  String? responseTime;
  String? accessTime;
  String? completeTime;

  List<String>? requestImage = [];

  Reports({
    this.reportId,
    this.reportNum,
    this.cateName,
    this.userId,
    this.reportName,
    this.reportDesc,
    this.reportAddress,
    this.requestDate,
    this.reportStatus,
    this.responseLocation,
    this.responseTime,
    this.accessTime,
    this.completeTime,

    this.requestImage,
  });

// BeauticianDetails();
  Reports.fromJson(Map<String, dynamic> parsedJSON)
      : reportId = parsedJSON['reportId'],
        reportNum = parsedJSON['reportNum'],
        cateName = parsedJSON['cateName'],
        userId = parsedJSON['userId'],
        reportName = parsedJSON['reportName'],
        reportDesc = parsedJSON['reportDesc'],
        reportAddress = parsedJSON['reportAddress'],
        requestDate = DateTime.parse(parsedJSON['requestDate'] as String),
        reportStatus = parsedJSON['reportStatus'],
        responseLocation = parsedJSON['responseLocation'],
        responseTime = parsedJSON['responseTime'],
        accessTime = parsedJSON['accessTime'],
        completeTime = parsedJSON['completeTime'],

      requestImage =
            (parsedJSON['requestImage'] as List).map((e) => e as String).toList()

  ;

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'reportNum': reportNum,
      'cateName': cateName,
      'userId': userId,
      'reportName': reportName,
      'reportDesc': reportDesc,
      'reportAddress': reportAddress,
      'requestDate': requestDate?.toIso8601String(),
      'reportStatus': reportStatus,
      'responseLocation': responseLocation,
      'responseTime': responseTime,
      'accessTime': accessTime,
      'completeTime': completeTime,

      'requestImage': requestImage,
    };
  }

  static Reports reportInfo = Reports(
    reportId: '',
    cateName: '283764',
    userId: GlobalData.currentUser.uid,
    reportName: '',
    reportDesc: '',
    reportAddress: '24.667170408458254&46.71415238724649',
    requestDate: DateTime.now(),
    reportStatus: '',
    requestImage: [],
  );
  static Reports reportInfo1f3 = Reports(
    reportId: '',
    cateName: '283764',
    userId: '',
    reportName: 'civilDefense',
    reportDesc:
        '  ',
    reportAddress: '24.667170408458254&46.71415238724649',
    requestDate: DateTime.now(),
    reportStatus: 'inProgress',
    requestImage: [],
  );
}

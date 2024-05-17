import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Emergency/model/user_model.dart';
import 'package:Emergency/util/sharedPref.dart';

import '../main.dart';
import '../model/reports.dart';
import '../util/global_data.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  CollectionReference getReportsCollection() {
    final CollectionReference reportCollection =
        FirebaseFirestore.instance.collection('Reports');
    return reportCollection;
  }

  CollectionReference getUsersCollection() {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    return userCollection;
  }

  Future<String> getRows(collection, field, value) async {
    QuerySnapshot _myDoc;

    _myDoc = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length.toString();
  }

  getUserInfo(String uid) async {
    return getUsersCollection()
        .where("uid", isEqualTo: uid)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future addReportData(Reports report) async {
    String reportId = getReportsCollection().doc().id;
    report.reportId = reportId;
    await getReportsCollection()
        .doc(reportId)
        .set(report.toMap())
        .catchError((e) {
      print(e);
    });
  }

  Stream<List<Reports>> getReports(cateName) {
    return cateName == 'admin'
        ? getReportsCollection()
            .snapshots()
            .map((snapShot) => snapShot.docs
                .map((document) =>
                    Reports.fromJson(document.data() as Map<String, dynamic>))
                .toList())
        : getReportsCollection()
            .where('cateName', isEqualTo: cateName)
            .snapshots()
            .map((snapShot) => snapShot.docs
                .map((document) =>
                    Reports.fromJson(document.data() as Map<String, dynamic>))
                .toList());
  }

  Future cancelReport(reportId) async {
    await getReportsCollection().doc(reportId).delete();
  }

  Stream<List<Reports>> getMyReports(String userId) {
    return getReportsCollection()
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) =>
                Reports.fromJson(document.data() as Map<String, dynamic>))
            .toList());
  }
}

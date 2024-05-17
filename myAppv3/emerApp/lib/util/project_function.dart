import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

import '../api/database.dart';
import '../model/reports.dart';
import '../model/user_model.dart';
enum AuthMode { signUp, login }

Future<bool?> requestStoragePermission() async {
  if (!await Permission.storage.isGranted) {
    PermissionStatus result = await Permission.storage.request();
    if (result.isGranted)
      return true;
    else
      return false;
  }
  return null;
}
Future<String>getDirectoryPath() async
{
  Directory? appDocDirectory = await getExternalStorageDirectory();
  // Directory directory= await new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true);
  return appDocDirectory!.path;
}
Future<bool> requestWritePermission() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  }else
  {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    return false;
  }
}



Future<String> getCurrentAddress(double latitude,double longitude,context) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude
  );
  List<Address> results = [];
  var first = placemarks.first;
  if (first != null) {
    var address;

    address = first.locality != null ? first.locality : '';
    address = " $address, ${first.subLocality != null ? first.subLocality : ''}";
    address = " $address, ${first.thoroughfare != null ? first.thoroughfare : ''}";


    // address = first.thoroughfare != null ? first.thoroughfare : '';
    // address = " $address, ${first.subLocality != null ? first.subLocality : ''}";
    // address = " $address, ${first.locality != null ? first.locality : ''}";

    String? name = first.name;
    String? subLocality = first.subLocality;
    String? locality = first.locality;
    String? administrativeArea = first.administrativeArea;
    String? postalCode = first.postalCode;
    String? country = first.country;
    String? thoroughfare = first.thoroughfare;
    String? street = first.street;
    String? subThoroughfare = first.subThoroughfare;
    String? isoCountryCode = first.isoCountryCode;
    // print(name);
    // print(subLocality);
    // print(locality);
    // print(administrativeArea);
    // print(postalCode);
    // print(country);
    // print(thoroughfare);
    // print(street);
    // print(subThoroughfare);
    // print(isoCountryCode);
    return address;
  }
  else
    return 'Not Found Address';
}
Future<UserModel> getUserInfo(id,) async {
  QuerySnapshot empInfoSnapshot =
  await DatabaseService(uid: '').getUserInfo(id);
  return UserModel.fromJson(empInfoSnapshot.docs[0].data() as Map<String, dynamic>);
}
Future<UserModel> getUserInfo1(id,) async {
  QuerySnapshot empInfoSnapshot =
  await DatabaseService(uid: '').getUserInfo(id);
  return UserModel.fromJson(empInfoSnapshot.docs[0].data() as Map<String, dynamic>);
}
Future<Reports> getReport(id,) async {
  QuerySnapshot snapshot =
  await DatabaseService(uid: '').getReportInfo(id);
  return Reports.fromJson(snapshot.docs[0].data() as Map<String, dynamic>);
}
Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    BuildContext context, String assetName) async {
  // Read SVG file as String
  String svgString =
  await DefaultAssetBundle.of(context).loadString(assetName);
  // Create DrawableRoot from SVG String
  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

  // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width =
      32 * devicePixelRatio; // where 32 is your SVG's original width
  double height = 32 * devicePixelRatio; // same thing

  ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
  ui.Image image = await picture.toImage(width.toInt(), height.toInt());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}



import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/database.dart';
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



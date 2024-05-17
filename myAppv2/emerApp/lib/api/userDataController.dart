import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../model/user_model.dart';
import '../util/sharedPref.dart';

class UserDataController with ChangeNotifier {
  UserModel? user;
  Future<UserModel?> get currentUserInfo async {
    if (user == null) {
      await getUserData();
      return user;
    } else {
      await getUserData();

      return user;
    }
  }

  Future<void> registerUser(UserModel guestData) async {
    try {
      final db = FirebaseFirestore.instance;  //   create object
      await db.collection('users').doc(globalUserId).set(guestData.toMap()); //use collection('users') use set
      globalCurrentUserImageUrl = guestData.photoUrl;
          notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      SharedPref sharedPref=SharedPref();
      await sharedPref.save('userInfo', guestData.toMap());
    } catch (error) {
      print(error);
    }
  }
  Future<void> fetchUserData() async {
    SharedPref sharedPref=SharedPref();
    UserModel temp;
    try {
      final db = FirebaseFirestore.instance;

      final docRef = await db.collection('users').doc(globalUserId);
      final ref = docRef.get();

      await docRef.get().then(
        (DocumentSnapshot doc) async {
          await sharedPref.save('userInfo', doc.data());

          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          globalCurrentUserImageUrl = data['photoUrl'];

          if (data['uid'] == FirebaseAuth.instance.currentUser!.uid) {
          }
          user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
        },
        onError: (e) => print(e),
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> getUserData() async {
    SharedPref sharedPref=SharedPref();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userInfo') || prefs.get('userInfo') == null) {
      if (kDebugMode) {
        print('not exist');
      }
      fetchUserData();
      return;
    } else {
      if (kDebugMode) {
        print('exist');
      }
      user =  UserModel.fromJson(await sharedPref.read("userInfo")??'');
    }
  }

  Future<UserModel?> getUserDataById(String userId) async {
    SharedPref sharedPref=SharedPref();

    try {
      final db = FirebaseFirestore.instance;

      final docRef = await db.collection('users').doc(userId);
      final ref = docRef.get();
      await docRef.get().then(
            (DocumentSnapshot doc) async {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
          // print('from single retrive data   ${user!.imageUrl}');
          await sharedPref.save('userInfo', doc.data());
        },
        onError: (e) => print(e),
      );

    } catch (error) {
      print('error in get user data by id : $error');
    }
    return user;

  }
}

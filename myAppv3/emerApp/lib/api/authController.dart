// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:found_and_lost/view/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../util/project_function.dart';

class AuthenticationController with ChangeNotifier {
  String? _token;
  String? _userId;
  AuthenticationController();

  late User user;
  UserCredential? userCredential;

  final authFirebaseInstance = FirebaseAuth.instance;


  String? get token {
    if ( _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId {
    if (_userId != null) {
      return _userId;
    } else {
      return null;
    }
  }

  bool get isAuth {
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> authUser(String email, String password, AuthMode auth) async {
    if (auth == AuthMode.login) {
      userCredential = await authFirebaseInstance.signInWithEmailAndPassword(
          email: email, password: password);
    } else {
      userCredential = await authFirebaseInstance.createUserWithEmailAndPassword(
          email: email, password: password);
    }
    _userId = userCredential!.user!.uid;
    _token = await userCredential!.user!.getIdToken();
    globalUserId = userCredential!.user!.uid;
    isAuth;
    notifyListeners();

    /// to store user data on device
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'email': email,
      'password': password,
    });
    prefs.setString('userData', userData);

  }
  Future<void> signUp(String email, String password) async {
    return authUser(email, password, AuthMode.signUp);
  }

  Future<void> login(String email, String password) async {
    return authUser(email, password, AuthMode.login);
  }



  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    if(FirebaseAuth.instance.currentUser==null){
      return false;
    }
    if (!prefs.containsKey('userInfo')) {
      return false;
    }
    else
      globalUserId = FirebaseAuth.instance.currentUser!.uid;
    return true;
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
    _token = null;
    _userId = null;
    notifyListeners();
    globalUserId=null;
    globalCurrentUserImageUrl=null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.remove('userInfo');
    prefs.clear();
  }

}

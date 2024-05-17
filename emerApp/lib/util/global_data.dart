
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class GlobalData {
   static final String _strokeSvgPath = "assets/";
   static final String mapPinStrokeSvg = _strokeSvgPath + "map_pin_svg.svg";
   static final String filterStrokeSvg = _strokeSvgPath + "filter_svg.svg";
   static final String searchStrokeSvg = _strokeSvgPath + "search_svg.svg";
   static final String mapStrokeSvg = _strokeSvgPath + "map_svg.svg";
   static final String logo = "assets/Images/logo2.png";
   static final String logoWait = "assets/Images/logoWait.png";

   static UserModel currentUser=new UserModel();
   static String cateName='';
   static String reportName='';
static String globalProfile='https://firebasestorage.googleapis.com/v0/b/savior-mobile.appspot.com/o/user_images%2Fuser.png?alt=media&token=15f31ce4-40b4-485a-966e-ea94e9106a42';
   static final String heartStrokeSvg = _strokeSvgPath + "heart_svg.svg";

   static String reportAddress=   '';
   // static String reportAddress='24.666953784261764&46.72047849744558';
   String get getReportAddress {
     return reportAddress;
   }
   set getReportAddress(String value) {
     if(value ==null) {
       throw new ArgumentError();
     }
     reportAddress = value;
   }
   UserModel get getEmpInfo {
     return currentUser;
   }
   set getEmpInfo(UserModel value) {
     if(value ==null) {
       throw new ArgumentError();
     }
     currentUser = value;
   }
   String get getCateName {
     return cateName;
   }
   set getCateName(String value) {
     if(value ==null) {
       throw new ArgumentError();
     }
     cateName = value;
   }

   String get getReportName {
     return reportName;
   }
   set getReportName(String value) {
     if(value ==null) {
       throw new ArgumentError();
     }
     reportName = value;
   }
}

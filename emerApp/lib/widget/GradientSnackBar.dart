import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Emergency/values/colors.dart';

class GradientSnackBar{
  static void showMessage(BuildContext context, String message){
    Flushbar(
      message: message,
      duration: Duration(milliseconds: 2500),
      backgroundGradient:LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStartColor,
            AppColors.gradientEndColor
          ])
      ,backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: AppColors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }
  static void showError(BuildContext context, String error){
    Flushbar(
      title: 'Error',
      titleColor: AppColors.redDark,
      icon: Icon(Icons.error,color: AppColors.red,),
      message: error,
      duration: Duration(milliseconds: 2500),
      backgroundGradient:LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomRight,
          colors: [
            AppColors.errorGradientStartColor,
            AppColors.errorGradientEndColor
          ])
      ,backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: AppColors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
    )..show(context);
  }

}
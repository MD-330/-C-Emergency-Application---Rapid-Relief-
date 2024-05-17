
import 'package:flutter/material.dart';

import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/spaces.dart';

class SettingItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String txt;
  final bool? checkText;

  final Widget leftWidget;
  final GestureTapCallback onTap;
  const SettingItem({
    required this.color,
    required this.icon,
    required this.txt,
    this.checkText,
    required this.leftWidget,
    required this.onTap,
  })  : assert(color != null);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppColors.white,
//        height: 120,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Container(
//                width: 30,
//                height: 30,
                // margin: EdgeInsets.only(top: 5,bottom: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  color: color,
                ),
                child: Icon(
                  icon,
                  color: AppColors.white,
                )),
            SpaceW12(),
            Expanded(
              // flex: 6,
              child: Text(checkText!=null&&checkText!?
                getTranslated(context, txt):txt,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0,color: AppColors.black),
              ),
            ),
            leftWidget
          ],
        ),
      ),
    );
  }
}

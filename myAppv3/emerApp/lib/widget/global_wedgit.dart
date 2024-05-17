import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../api/database.dart';
import '../main.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/sizeHelper.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../values/spaces.dart';
import 'custom_svg_view.dart';

String getDateMilliseconds(int time) {
  return DateTime.fromMillisecondsSinceEpoch(time, isUtc: true).toString().substring(0, 16);
}

String getDateFromMicro1(String date) {
  var dateTime = new DateTime.fromMicrosecondsSinceEpoch(int.parse(date));
  return DateFormat('yyyy, MMM, dd').format(dateTime);
}

String getDateFromMicro(String date) {
  var dateTime = new DateTime.fromMicrosecondsSinceEpoch(int.parse(date));
  return DateFormat('yyyy, MMMM, dd').format(dateTime);
}

String getName(String file) {
  return basename(File(file).path);
}

double getLatitude(String location) {
  return double.parse(location.substring(0, location.indexOf('&')));
}

double getLongitude(String location) {
  return double.parse(location.substring(location.indexOf('&') + 1));
}

String getFileName(String fileName) {
//  1618874511200 _ Student Complaints Application.pdf.aes
  if (fileName.indexOf("_") == 14 && fileName.endsWith("aes"))
    return fileName.substring(fileName.indexOf("_") + 1, fileName.indexOf("aes") - 1);
  else
    return fileName;
}

getTitleWithIcon(title, onTap, context) {
  return Row(
    children: <Widget>[
      Expanded(
          child: getRowWidget(
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.0,
            color: AppColors.black.withOpacity(0.5),
          ),
        ),
      )),
      InkWell(
        onTap: onTap,
        child: Row(children: <Widget>[
          Text(
            getTranslated(context, 'viewMore'),
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: AppColors.black.withOpacity(.4)),
          ),
          SpaceW4(),
          Icon(Icons.arrow_forward, color: AppColors.primary),
        ]),
      ),
    ],
  );
}

String getDate() {
  String date = "${DateTime.now().toLocal()}".split(' ')[0] +
      "  " +
      "${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}".split(' ')[0];
  return date;
}

Decoration getBackgroundContainer() {
  return BoxDecoration(
    color: AppColors.white.withOpacity(1),
    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: AppColors.grey.withOpacity(0.2),
        offset: const Offset(1.2, 1.2),
        blurRadius: 5,
      ),
    ],
  );
}

getText(text, double fontSize, FontWeight fontWeight, Color color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      // color: AppColors.allLabel,
      color: color,
    ),
  );
}

Row getRowWidget(Widget widget) {
  return Row(children: <Widget>[Expanded(flex: 1, child: widget)]);
}

getRowNumber(collection, field, value, double fontSize, FontWeight fontWeight, Color color) {
  return FutureBuilder<String>(
    future: DatabaseService(uid: '').getRows(collection, field, value),
    // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      List<Widget> children;
      if (snapshot.hasData) {
        children = <Widget>[getText('${snapshot.data} ', fontSize, fontWeight, color)];
      } else if (snapshot.hasError) {
        children = <Widget>[getText("0 ", fontSize, fontWeight, color)];
      } else {
        children = const <Widget>[
          SizedBox(
            child: CircularProgressIndicator(),
          ),
        ];
      }
      return Center(
        child: Column(
          children: children,
        ),
      );
    },
  );
}

String basename1(String file) {
  return basename(File(file).path);
}

class CustomTextInput extends StatelessWidget {
  final bool? isObsecure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final int? maxLines;
  final bool? autofocus;
  final String? labelText;
  final Widget? suffixIcon;

  final Widget? label;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onChanged;

  CustomTextInput({
    Key? key,
    this.isObsecure,
    this.keyboardType,
    this.controller,
    this.focusNode,
    this.hintText,
    this.autofocus,
    this.maxLines,
    this.labelText,
    this.nextFocusNode,
    this.icon,
    this.label,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Container(
      height: 53,

      padding: EdgeInsets.only(left: size.setWidth(7)),
      margin: EdgeInsets.symmetric(horizontal: size.setWidth(10)),

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      // width: size.setWidth(310),
      child: TextFormField(
        keyboardType: keyboardType,
        focusNode: focusNode,
        autofocus: autofocus != null ? autofocus! : false,
        maxLines: maxLines != null ? maxLines : 1,
        controller: controller,
        obscureText: isObsecure!,
        style: TextStyle(
          fontSize: 13,
          overflow: TextOverflow.ellipsis,
        ),

        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          // labelText: labelText,
          label: label,
          // icon: FieldIcon(icon!),
          // hintText: hintText,
          suffixIcon: suffixIcon,
          // enabledBorder: UnderlineInputBorder(
          //   //<-- SEE HERE
          //   borderSide: BorderSide(width: 1, color: AppColors.black.withOpacity(.3)),
          // ),
          border: OutlineInputBorder(),
          hintStyle: TextStyle(fontSize: 11),
          // prefixIcon: Icon(
          //   icon,
          // ),
        ),
        onChanged: onChanged,
        onFieldSubmitted: (userName) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }
}

class FieldIcon extends StatelessWidget {
  late final IconData icon;

  FieldIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    final size = SizeHelper(context);
    return Icon(
      icon,
      color: Colors.grey,
      size: size.setWidth(22),
    );
  }
}

String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if(languageCode=='ar'){
    timeAgo.setLocaleMessages(languageCode.toString(), timeAgo.ArMessages());
    return timeAgo.format(now.subtract(difference), locale: languageCode.toString());
  }
 return timeAgo.format(now.subtract(difference), locale: 'en');

}

class CustomActionButton extends StatelessWidget {
  final String? icon;
  final VoidCallback? onTap;
  final Color? color;
  final double? height;
  final double? width;
  final double? iconSize;
  final double? radius;

  final bool? takeDefaultColor;

  CustomActionButton({
    Key? key,
    this.onTap,
    this.icon,
    this.color,
    this.takeDefaultColor,
    this.height,
    this.width,
    this.iconSize,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: height ?? 45,
        width: width ?? 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 7),
          border: Border.all(
            color: AppColors.text_100,
          ),
        ),
        alignment: Alignment.center,
        child: CustomSvgView(
          imageUrl: icon ?? GlobalData.heartStrokeSvg,
          isFromAssets: true,
          width: iconSize ?? 15,
          height: iconSize ?? 15,
          svgColor: color ?? AppColors.black,
        ),
      ),
    );
  }
}

class CheckDialog extends StatelessWidget {
  const CheckDialog({
    Key? key,
    this.title,
    this.content,
    this.pressYes,
    this.pressNo,
  }) : super(key: key);
  final String? title;
  final String? content;
  final GestureTapCallback? pressYes;
  final GestureTapCallback? pressNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content: Text(content!),
      actions: [
        TextButton(child: Text(getTranslated(context, 'no')), onPressed: pressNo),
        TextButton(
          child: Text(getTranslated(context, 'yes')),
          onPressed: pressYes,

          //onPressed: pressYes,
        )
      ],
    );
  }
}

Future showBottomDialog<T>({
  required BuildContext context,
  Widget? contentWidget,
  bool allowBackNavigation = false,
}) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    isDismissible: allowBackNavigation,
    builder: (context) => WillPopScope(
      onWillPop: () async => allowBackNavigation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
        child: contentWidget,
      ),
    ),
  );
}

void showMyDialog(BuildContext context) {
  showBottomDialog<dynamic>(
    context: context,
    allowBackNavigation: true,
  );
}

Widget getIconSocial(iconName) {
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      // color: AppColors.black,
      border: Border.all(color: AppColors.white, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    child: Image.asset(
      'assets/icons/' + iconName,
      fit: BoxFit.contain,
      color: AppColors.white,
      height: 24,
    ),
  );
}
class GetStatus extends StatelessWidget {
  const GetStatus(
      {Key? key,
        required this.status})
      : super(key: key);

  final String status;
  @override
  Widget build(BuildContext context) {
    return Text(
      getTranslated(
          context, status),
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 11,
        fontWeight:
        FontWeight.normal,
        letterSpacing: .5,
        height: 1.3,
      ),
      softWrap: false,
      overflow:
      TextOverflow.clip,
      maxLines: 1,
    );
  }
}

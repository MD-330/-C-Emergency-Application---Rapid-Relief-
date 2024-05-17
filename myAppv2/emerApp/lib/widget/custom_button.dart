import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final String? text;
  final Widget? image;
  final GestureTapCallback? onPressed;

  const CustomButton({
    @required this.color,
    @required this.borderColor,

    @required this.textColor,
    @required this.text,
    @required this.onPressed,
    this.image,
  })  : assert(color != null),
        assert(textColor != null),
        assert(text != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
   return
    InkWell(
      onTap: onPressed,
      child: Container(
        // margin: EdgeInsets.only(right: 30, left: 30),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor!,width: 1),
          color: color,
//        gradient: largeButton(color),
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 28, vertical: 0),
          child: Center(
            child: Text(
              text!,
              style:  TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 0.27,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../values/colors.dart';

class CustomInputField extends StatelessWidget {
  final String? label;
  final IconData? prefixIcon;
  final bool? obscureText;
  final Color? textColor;
  final  double? radius;
  final Color? radiusColor;

  final TextInputType? type;
  final TextEditingController? textEditingController;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;

  final FormFieldValidator<String>? validator;

  final Widget? trailing;

  const CustomInputField({
    this.label,
     this.prefixIcon,
     this.textColor,
     this.type,
     this.radius,
     this.radiusColor,
    this.textEditingController,
    this.onChanged,
      this.onSaved,
     this.trailing,
     this.validator,

    this.obscureText = false,
  })  : assert(label != null),
        assert(prefixIcon != null);

  @override
  Widget build(BuildContext context) {

    return  Container(
      height: 53,
      decoration: BoxDecoration(
        border: Border.all(color: textColor!,width: .5),
        color: AppColors.white,
        borderRadius:  BorderRadius.all(
          Radius.circular(radius!),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(0),
        child:   ListTile(
          title: TextFormField(
            keyboardType: type,
            controller: textEditingController,
            onChanged: onChanged,

            style: TextStyle(color: textColor,fontSize: 13),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: label,
              hintStyle: TextStyle(
                color: textColor!.withOpacity(.5),
                fontWeight: FontWeight.w400,
                fontSize: 13
              ),

              prefixIcon: Icon(
                prefixIcon,
                color: textColor,
              ),

            ),
            validator:validator,
            obscureText: obscureText!,
            onSaved: onSaved,
          ),
          trailing: trailing??  trailing,
        ),
      ),
    );
  }
}

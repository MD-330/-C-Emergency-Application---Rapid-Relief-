import 'package:flutter/material.dart';
import 'package:Emergency/values/colors.dart';

import '../util/global_data.dart';
import 'custom_svg_view.dart';

/// ignore: must_be_immutable
class CustomSearchbar extends StatelessWidget {
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final String? hintText;
  final String? icon;
  final String? actionIcon;
  final VoidCallback? onSearchActionTap;
  CustomSearchbar({
    Key? key,
    this.height,
    this.width,
    this.controller,
    this.onSearchActionTap,
    this.hintText,
    this.icon,
    this.actionIcon,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: height ?? 55,
      width: width ?? screenSize.width,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color:  AppColors.light_300,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomSvgView(
            imageUrl: icon ?? GlobalData.searchStrokeSvg,
            isFromAssets: true,
            height: 20,
            width: 19,
            svgColor:  AppColors.text_200,
          ),
          SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText ?? "",
                hintStyle: TextStyle(
                  color:  AppColors.text_200,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                )
              ),
              style: TextStyle(
                color:  AppColors.text_900,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              )

            ),
          ),
          GestureDetector(
            onTap: onSearchActionTap ?? () {},
            child: Container(
              padding: EdgeInsets.all(10),
              color: AppColors.transparent,
              child: CustomSvgView(
                imageUrl: actionIcon ?? GlobalData.filterStrokeSvg,
                isFromAssets: true,
                height: 19,
                width: 19,
                svgColor:  AppColors.text_900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

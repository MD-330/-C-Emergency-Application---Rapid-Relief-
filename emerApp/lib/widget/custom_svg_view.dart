import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// THIS IS THE CLASS FOR SHOW SVG...
class CustomSvgView extends StatelessWidget {
  final String? imageUrl;
  final bool? isFromAssets;
  final double? height;
  final double? width;
  final Color? svgColor;

  const CustomSvgView(
      {Key? key,
      this.imageUrl,
      this.isFromAssets,
      this.height,
      this.width,
      this.svgColor})
      : assert(imageUrl != "" && imageUrl != null);

  @override
  Widget build(BuildContext context) {
    return isFromAssets ?? true
        ? SvgPicture.asset(
            imageUrl!,
            height: height ?? 15,
            width: width ?? 15,
            color: svgColor ,
          )
        : SvgPicture.network(
            imageUrl!,
            height: height ?? 15,
            width: width ?? 15,
            color:svgColor ,
          );
  }
}

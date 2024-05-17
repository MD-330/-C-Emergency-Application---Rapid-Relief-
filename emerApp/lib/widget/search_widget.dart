import 'package:flutter/material.dart';
import 'package:Emergency/values/colors.dart';

import '../util/language_constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
    this.onChanged,
    this.controller,
    this.onTap,
  }) : super(key: key);

  final TextEditingController? controller;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(left: 22, right: 22,top: 0),

              padding: EdgeInsets.only(left: 22, right: 22,top: 0),
              child: Container(
                height: 59,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: new ListTile(
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(fontSize: 14),
                        hintText: getTranslated(context, 'search'), border: InputBorder.none),
                    onChanged: onChanged,
                  ),
                  trailing: new InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(38.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: new Icon(Icons.clear, color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

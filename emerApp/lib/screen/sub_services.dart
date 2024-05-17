import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../model/services.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/global_wedgit.dart';
import '../widget/search_widget.dart';
import 'add_report_screen.dart';
import 'home_screen.dart';

class SubServicesScreen extends StatefulWidget {
  List<Services>? servList;
  SubServicesScreen({this.servList});
  @override
  _SubServicesScreenState createState() => _SubServicesScreenState();
}

class _SubServicesScreenState extends State<SubServicesScreen>
    with TickerProviderStateMixin {
    late AnimationController animationController;
  List<Services> servList=[];
  bool multiple = true;
    int currentIndex = 0;
    double iconSize = 25.0;

  void _submitForm() async {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    setState(() {
      servList=widget.servList!;
    });
  }
    @override
  void didChangeDependencies() {
    setState(() {
        currentIndex = 0;
      });
      super.didChangeDependencies();
  }
  @override
  void initState() {
    _submitForm();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
    Future<bool> _onBackPressed() async {
      final shouldPop = await  Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(initialIndex: 1,), // Destination
        ),
            (route) => false,
      );
      return shouldPop ?? false;
    }
    @override
  Widget build(BuildContext context) {
      var size = MediaQuery.of(context).size;
      final double itemHeight = (size.height*.515) / 2;
      final double itemWidth = size.width / 2;
      return WillPopScope(
          onWillPop: _onBackPressed,
        child:
        Scaffold(
        backgroundColor: AppColors.whiteShade2,
        body:  Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Container(
                  padding:
                  EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 15),
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.centerLeft,
                      begin: Alignment.centerRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary,
                        AppColors.primary.withOpacity(.9),
                        AppColors.primary.withOpacity(.8),
                        // AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                           getTranslated(context, GlobalData.cateName),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                height: 1.3,
                                color: AppColors.white.withOpacity(1)),
                          ),
                        ),
                      ],
                    ),
                    SpaceH4(),
                  ])),
            ]),
            Positioned(
                left: 0,
                top: 85,
                right: 0,
                child: SearchWidget(
                  onTap: () {},
                )),
            Positioned(
                left: 0,
                top: 150,
                bottom: 0,
                right: 0,
                child: Container(
                    color: AppColors.transparent,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      color: AppColors.transparent,
                      child: Column(children: <Widget>[
                        Expanded(
                            child: Container(
                              color: AppColors.white,
                              child:  GridView(
                                padding:
                                const EdgeInsets.only(top: 0, left: 12, right: 12),
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: List<Widget>.generate(
                                  servList.length,
                                      (int index) {
                                    final int count = servList.length;
                                    final Animation<double> animation =
                                    Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    );
                                    animationController.forward();
                                    return servItem(
                                      animation: animation,
                                      animationController: animationController,
                                      cateData: servList[index], callback: () {  },
                                    );
                                  },
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: multiple ? 2 : 1,
                                  mainAxisSpacing: 1.0,
                                  crossAxisSpacing: 1.0,
                                  // childAspectRatio: 1.0,
                                  childAspectRatio:
                                  (itemWidth / itemHeight),
                                ),
                              ),
                            )),
                      ]),
                    ),))
          ],
        )
      )
      );
  }
}


class servItem extends StatelessWidget {
  const servItem(
      {Key? key,
      this.cateData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Services? cateData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  void goBack(BuildContext context) {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: getBackgroundContainer(),
                child:  Padding(
                  padding: const EdgeInsets.all(0),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            GlobalData.reportName=cateData!.name;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddReportScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3,vertical: 9),
                            // width: 100.0,
                            // height: 100.0,
                            decoration: new BoxDecoration(
                              //  color: AppColors.darkBlue,
                              shape: BoxShape.rectangle,
                              // image: new DecorationImage(
                              //     fit: BoxFit.fill,
                              //     image: AssetImage(cateData.imagePath,)),
                            ),
                            child: Image.asset(
                              'assets/subCate/${cateData!.name}.png',
                              height: 110,
                              fit: BoxFit.cover,
                              // color: AppColors.iconColor.withOpacity(1),
                            ),
                          )),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 40,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(0.0)),
                                  color: AppColors.notWhite,
                                ),
                                alignment: Alignment.centerLeft,
                                child:
                                getRowWidget(Text(
                                    getTranslated(context,  cateData!.name,),

                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        letterSpacing: .1),
                                    textScaleFactor: 1.4))),
                            // Container(
                            //   padding: EdgeInsets.all(3),
                            //   decoration: BoxDecoration(
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(0.0)),
                            //     color: AppColors.notWhite,
                            //   ),
                            //   child:
                            //
                            //     Row(
                            //       children: <Widget>[
                            //         getRowNumber(
                            //             'posts',
                            //             'category',
                            //             cateData!.name,
                            //             12,
                            //             FontWeight.w500,
                            //             AppColors.black.withOpacity(.5)),
                            //
                            //         Text(
                            //           'Items',
                            //           style: TextStyle(
                            //             // h4 -> display1
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 12,
                            //             letterSpacing: 0.4,
                            //             //height: 0.9,
                            //             color: AppColors.black.withOpacity(.5),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //
                            //   )
                          ]),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }
}

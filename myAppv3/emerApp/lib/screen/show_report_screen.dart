import 'dart:io';
import 'dart:math';

import 'package:Emergency/model/reports.dart';
import 'package:Emergency/values/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../util/language_constants.dart';
import '../util/project_function.dart';
import '../values/spaces.dart';
import '../widget/global_wedgit.dart';

class ShowReportScreen extends StatefulWidget {
  final Reports reportDetails1;
  const ShowReportScreen({Key? key, required this.reportDetails1}) : super(key: key);
  @override
  _ShowReportScreenState createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen>
    with TickerProviderStateMixin {
  late Reports reportDetails;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool checkValidation = false;
  String lastTap = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String location = '';
  Random randomGenerator = Random();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    location = getTranslated(context, 'notFoundAddress');
    reportDetails = widget.reportDetails1;
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      // reportDetails = widget.reportDetails;
    });
    reportDetails = widget.reportDetails1;
    getCurrentLocation();
    super.initState();
  }


  Set<Marker> _markers = {};
  LatLng? latlong ;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;

  getLocation() async {
    if (reportDetails.reportAddress!.isEmpty) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        reportDetails.reportAddress =
            latitude.toString() + '&' + longitude.toString();
      });
    } else {
      setState(() {
        latitude = getLatitude(reportDetails.reportAddress!);
        longitude = getLongitude(reportDetails.reportAddress!);
      });
    }
    setState(() {
//      latlong=new LatLng(position.latitude, position.longitude);
      latlong = new LatLng(latitude, longitude);
      _cameraPosition = CameraPosition(target: latlong!, zoom: 16.0);
      if (_controller != null)
        _controller!
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      _markers.add(Marker(
          markerId: MarkerId("a"),
          draggable: true,
          position: latlong!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          onDragEnd: (_currentlatLng) {
            latlong = _currentlatLng;
          }));
    });
  }

  Future getCurrentLocation() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      if (!await Permission.location.request().isGranted) {
        print('no storage permission to use location');
        return;
      } else {
        getLocation();
      }
    } else {
      getLocation();
    }
  }


  Widget getTitel(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: <Widget>[
        Icon(
          icon,
          color: AppColors.primary,
          size: 25,
        ),
        SpaceW4(),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        )
      ]),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: AppColors.transparent,
      child: _body(),
    ));
    //
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Container(
          width: size.width,
          height: size.height * .4,
          child: Stack(children: [
            GoogleMap(
//                    myLocationEnabled: true,
//                    myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 16.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = (controller);
                _controller!.animateCamera(
                    CameraUpdate.newCameraPosition(_cameraPosition!));
              },
              markers: _markers,
            ),
            Positioned(
              top: 25.0,
              right: 15.0,
              left: 15.0,
              child: Container(
                height: 65.0,
                width: double.infinity,
                child: Row(children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child:  Icon(
                      Icons.cancel_rounded,
                      color: AppColors.black.withOpacity(.3),
                      size: 40,
                    ),
                  )
                 ,
                  SpaceW4(),
                ]),
              ),
            ),
          ])),
      SpaceH10(),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Icon(
                Icons.app_registration,
                color: AppColors.primary,
                size: 25,
              ),
              SpaceW4(),
              Expanded(
                child: Text(
                  getTranslated(context, 'reportDetails1'),
                  maxLines: 4,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17.0,
                      color: AppColors.primary.withOpacity(.9)),
                ),
              ),
              Container(
                  child: Row(children: <Widget>[
                Icon(
                  Icons.description,
                  color: AppColors.black.withOpacity(.7),
                  size: 25,
                ),
                SpaceW4(),

              ])),
              SpaceW4(),
            ]),
            SpaceH10(),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Icon(
                      Icons.assignment,
                      color: AppColors.black.withOpacity(.7),
                      size: 25,
                    ),
                    SpaceW4(),
                    Expanded(
                      child: Row(children: <Widget>[
                        Text(
                          getTranslated(context, 'reportOn') +' : ' ,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: AppColors.black.withOpacity(.9)),
                        ),
                        SpaceW4(),
                        Text(
                          getTranslated(context, reportDetails.cateName!),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                              color: AppColors.primary0),
                        ),
                      ]),
                    ),
                    // Text(
                    //   getTranslated(context, 'reportOn')+getTranslated(context, reportDetails.cateName!),
                    //   maxLines: 4,
                    //   overflow: TextOverflow.clip,
                    //   softWrap: true,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 16.0,
                    //       color: AppColors.black.withOpacity(.9)),
                    // ),
                  ]),
                  SpaceH10(),
                ])),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    Icon(
                      Icons.assignment,
                      color: AppColors.black.withOpacity(.7),
                      size: 25,
                    ),
                    SpaceW4(),
                    Row(children: <Widget>[
                      Text(
                        getTranslated(context, 'emergencyIs')+' : ' ,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: AppColors.black.withOpacity(.9)),
                      ),
                      SpaceW4(),
                      Text(
                        getTranslated(context, reportDetails.reportName!),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: AppColors.primary0),
                      ),
                    ]),

                  ]),
                  SpaceH10(),

                ])),
            SpaceH10(),
            Container(
                child: Row(children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.confirmation_num_outlined,
                          color:AppColors.black.withOpacity(.5),
                          size: 20,
                        ),
                        SpaceW4(),
                        Text(
                          reportDetails.reportNum!,
                          maxLines: 4,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: AppColors.black.withOpacity(.7)),
                        )
                      ])),
                  SpaceW20(),
                  Container(
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.black.withOpacity(.5),
                          size: 20,
                        ),
                        SpaceW4(),
                        Text(
                          '${getTimeAgo(reportDetails.requestDate!)}',

                          maxLines: 4,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: AppColors.black.withOpacity(.7)),
                        )
                      ])),
                ])),
            SpaceH16(),
            Divider(
              color: AppColors.grey.withOpacity(.1),
              height: 3,
              thickness: 1,
            ),
          ])),
      SpaceH10(),
      Container(
          child: Column(children: <Widget>[
        getTitel(Icons.map_rounded, getTranslated(context, 'reportAddress')),
        SpaceH8(),
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: <Widget>[
              Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 25,
              ),
              SpaceW4(),
              Expanded(
                  child:  FutureBuilder<String>(
                    future: getCurrentAddress(getLatitude(reportDetails.reportAddress!),getLongitude(reportDetails.reportAddress!),context), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Row(children: <Widget>[
                            Text(
                              '${snapshot.data}',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: AppColors.black.withOpacity(.7)),
                            )]),
                        ];
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          Row(children: <Widget>[
                            Text(
                              getTranslated(context, 'notFoundAddress'),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.0,
                                  color: AppColors.black.withOpacity(.7)),
                            )]),

                        ];
                      } else {
                        children = const <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                          ),
                        ];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: children,
                        ),
                      );
                    },
                  )),
            ]),
          ),
        ),
        SpaceH12(),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: AppColors.grey.withOpacity(.1),
              height: 3,
              thickness: 1,
            )),
      ])),
      SpaceH10(),
          getTitel(Icons.post_add_outlined,
              getTranslated(context, 'reportDesc')),
          SpaceH6(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    reportDetails.reportDesc!.isNotEmpty? reportDetails.reportDesc!:getTranslated(context, 'noDetails'),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        height: 1.5,
                        color: AppColors.black.withOpacity(.7)),
                  ),
                ),
              ],
            ),
          ),
          SpaceH10(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
            color: AppColors.grey.withOpacity(.1),
            height: 3,
            thickness: 1,
            )),
          SpaceH10(),
          Container(
              child: Column(children: <Widget>[
                getTitel(Icons.add_photo_alternate,
                    getTranslated(context, 'reportPictures')),
                reportDetails.requestImage!.length>0?
                Container(
                    height: MediaQuery.of(context).size.height * .30,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(1.0)),
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * .25,
//                  aspectRatio: 16/9,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.decelerate,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: reportDetails.requestImage!.map((imgUrl1) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 0.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(4, 4),
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                    imageUrl: imgUrl1,
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0),
                                        image: DecorationImage(
                                            image: imageProvider, fit: BoxFit.cover),
                                      ),
                                    ))
                            );
                          },
                        );
                      }).toList(),
                    )): Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Text(
                          getTranslated(context, 'notFoundImage'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: AppColors.black.withOpacity(.5)),
                        )),
                  ]),
                ),
              ])),
      SpaceH16(),
        ]));
  }
}

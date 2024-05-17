import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../api/database.dart';
import '../model/reports.dart';
import '../poymap/directions_model.dart';
import '../poymap/directions_repository.dart';
import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../util/project_function.dart';
import '../util/sharedPref.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/GradientSnackBar.dart';
import '../widget/global_wedgit.dart';
import 'dart:ui' as ui; // imported as ui to prevent conflict between ui.Image and the Image widget
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
/// ignore: must_be_immutable
class TrackResponseScreen extends StatefulWidget {
  @override
  _TrackResponseScreenState createState() => _TrackResponseScreenState();
}

class _TrackResponseScreenState extends State<TrackResponseScreen> {
  int area = 30;
  bool _disposed = false;
String unit='كم';
  BitmapDescriptor? _selectedMarkerImage;
  BitmapDescriptor? _deselectedMarkerImage;
  BitmapDescriptor? _userMarkerImage;
  CameraPosition? _cameraPosition;
  int? hoursAttend;
  bool checkAvailableTime = false;
  int? minutesAttend;
  int? time=0;



  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  static const delay = Duration(microseconds: 1);
  Stopwatch stopwatch = Stopwatch();

  getMarker() async {
    // _selectedMarkerImage =
    //     await bitmapDescriptorFromSvgAsset(context, 'assets/icons/emergency.svg');
    _selectedMarkerImage =
        await bitmapDescriptorFromSvgAsset(context, 'assets/icons/map1.svg');
    _userMarkerImage =
        await bitmapDescriptorFromSvgAsset(context, 'assets/icons/map2.svg');
  }
  // double latitude = 24.667170408458254;
  // double longitude = 46.71415238724649;

  late CameraPosition _initialCameraPosition ;
  double latitude = 0.0;
  double longitude = 0.0;
  double distanceInMeters=0.0;
  double distanceInMetersCheck=0.0;
  double distanceInKMeters=0.0;
  double repLatitude =0.0;
  double repLongitude = 0.0;
  int? secondAttend;
  Timer? timer;
  String timeText = '';
  double zoom = 13.5;
  bool checkAgainVal = false;
  late SharedPref sharedPref;

  @override
  void dispose() {
    _disposed = true;
    _googleMapController!.dispose();
    super.dispose();
  }
  late Reports report;

  void distanceCalculation() async {
    report = await getReport(GlobalData.currentReport.reportId);
    GlobalData.currentReport = report;
    if (mounted) {
      setState(() {
        distanceInMeters = Geolocator.distanceBetween(                      //
            latitude, longitude, repLatitude, repLongitude);
        distanceInMetersCheck=distanceInMeters;
        if(distanceInMeters>1000){
          distanceInKMeters=distanceInMeters/1000;
          time=distanceInKMeters.round();
          time=(time!*1.5).round();
          distanceInKMeters= double.parse((distanceInKMeters).toStringAsFixed(2));
          unit=getTranslated(context, 'km');
        }
        else {
          distanceInKMeters = distanceInMeters.roundToDouble();
          unit=getTranslated(context, 'meter');
        }
      });
      getResponseLocation();
    }
  }
  void checkDistance() {
    Timer(
        Duration(seconds: 5),
            () =>  distanceCalculation()
    );
  }
  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 40 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  GoogleMapController? _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
      target: LatLng(24.667170408458254, 46.71415238724649),
      zoom: 4.9,
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMarker();
    });
    getResponseLocation();

  }
  Future<void> getLine() async {
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin!.position, destination: _destination!.position);
    setState(() => _info = directions);
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _destination!.position,
          zoom: zoom,
          tilt: 50.0,
        ),
      ),
    );
  }

  GoogleMapController? _controller;
  List<Map> locationList = [];

  getResponseLocation() async {
    BitmapDescriptor bitmapDescriptor = await _bitmapDescriptorFromSvgAsset(context, 'assets/icons/emergency.svg');
    setState(() {
      latitude=getLatitude(GlobalData.currentReport.responseLocation!);
      longitude=getLongitude(GlobalData.currentReport.responseLocation!);
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'loc'),
        icon:bitmapDescriptor,

        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(latitude, longitude),
      );
    });

    await getReportLocation();
  }
  getReportLocation() async {

    setState(() {
      repLatitude=getLatitude(GlobalData.currentReport.reportAddress!);
      repLongitude=getLongitude(GlobalData.currentReport.reportAddress!);
      _origin=Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'my location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: LatLng(repLatitude, repLongitude),

      );
      getLine();
      checkDistance();
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenSize.height - 100,
              width: screenSize.width,
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: {
                  if (_origin != null) _origin!,
                  if (_destination != null) _destination!
                },
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: AppColors.primary,
                      width: 5,
                      points: _info!.polylinePoints!
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                circles: {
                  Circle(
                    circleId: CircleId("1"),
                    center: LatLng(latitude, longitude),
                    radius: area.toDouble(),
                    fillColor: AppColors.primary.withOpacity(.3),
                    strokeColor: AppColors.transparent,
                    strokeWidth: 0,
                  )
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 90,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppColors.grey.withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Expanded(child: Text(
                      getTranslated(context, 'reportAddress'),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: AppColors.white.withOpacity(.9)),
                    ),),
                  ]),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.95),
            child: Container(
              height: 190,
              width: screenSize.width,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.light_200,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppColors.grey.withOpacity(0.5),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 6.0),
                ],
              ),
              child: Column(

                children: [
                  Row(children: <Widget>[
                    Expanded(child: Text(
                      getTranslated(context, 'reportAddress'),
                      maxLines: 4,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: AppColors.black.withOpacity(.9)),
                    ),),
                    InkWell(
                      onTap: (){
                        // getMyLocation();
                      },

                      child: Icon(
                        Icons.my_location,
                        color: AppColors.blackShade5,
                        size: 15,
                      ),)

                  ]),
                  // SpaceH10(),
                  Divider(
                    color: AppColors.grey.withOpacity(.2),
                    height: 3,
                    thickness: 1,
                  ),
                  SpaceH4(),
                  Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: AppColors.primary.withOpacity(.1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: FutureBuilder<String>(
                              future:
                              getCurrentAddress(latitude, longitude, context),
                              // a previously-obtained Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                List<Widget> children;
                                if (snapshot.hasData) {
                                  children = <Widget>[
                                    Row(children: <Widget>[

                                      Expanded(child: Text('${snapshot.data}',
                                          style: TextStyle(
                                            color: AppColors.text_900,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true),)
                                    ]),
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
                                      )
                                    ]),
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
                            ),
                          ),
                        ],
                      )),
                  SpaceH4(),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children:  <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  getTranslated(context, 'remainingTime')+' : ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: AppColors.blackShade5),
                                ),
                                Text(
                                 time.toString() ,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black.withOpacity(.7),
                                  ),
                                ),
                                Text(
                                  getTranslated(context, 'minutes') ,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black.withOpacity(.7),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Text.rich(
                              TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: distanceInKMeters.toString()+' ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.black.withOpacity(.7),
                                      fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                    text: unit,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: AppColors.blackShade5)),
                              ]),
                              textAlign:TextAlign.center,

                            )),
                      ],
                    ),
                  ),
                  Container(
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.black.withOpacity(.5),
                          size: 20,
                        ),
                        SpaceW4(),
                        Text(
                        getTranslated(context, 'requestTime'),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0, color: AppColors.black.withOpacity(.8)),
                        ),
                        Expanded(
                            child: Text(
                              '${getTimeAgo(GlobalData.currentReport.requestDate!)}',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.black.withOpacity(.7)),
                            ))
                      ])),
                  SpaceH8(),
                  Container(
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.black.withOpacity(.5),
                          size: 20,
                        ),
                        SpaceW4(),
                        Text(
                          getTranslated(context, 'responseTime'),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0, color: AppColors.black.withOpacity(.8)),
                        ),
                        Expanded(
                            child: Text(
                              '${getTimeAgo(DateTime.parse(GlobalData.currentReport.responseTime!))}',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12.0, color: AppColors.black.withOpacity(.7)),
                            ))
                      ])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

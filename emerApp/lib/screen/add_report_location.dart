import 'dart:async';
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../util/global_data.dart';
import '../util/project_function.dart';
import '../values/colors.dart';
import '../values/spaces.dart';
import '../widget/custom_searchbar.dart';
import '../widget/custom_svg_view.dart';
import '../widget/global_wedgit.dart';

/// ignore: must_be_immutable
class AddReportLocation extends StatefulWidget {
  @override
  _AddReportLocationState createState() => _AddReportLocationState();
}

class _AddReportLocationState extends State<AddReportLocation> {
  PageController? _pageController;
  late TextEditingController locationController;


  late BitmapDescriptor _selectedMarkerImage;
  late BitmapDescriptor _deselectedMarkerImage;
  late BitmapDescriptor _userMarkerImage;
  late CameraPosition _cameraPosition;
  LatLng? latlong;

  getMarker() async {
    _selectedMarkerImage = await _bitmapDescriptorFromSvgAsset(
        context, 'assets/map3.svg');
    _deselectedMarkerImage = await _bitmapDescriptorFromSvgAsset(
        context, 'assets/map1.svg');
    _userMarkerImage = await _bitmapDescriptorFromSvgAsset(
        context, 'assets/map2.svg');
    setState(() {});
  }

  Set<Marker> _markers = {};

  double latitude = 24.667170408458254;
  double longitude = 46.71415238724675;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController();
    getPlaceLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMarker();
    });
    _pageController = PageController(initialPage: 0);
//    getCurrentLocation();
  }


  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, '');

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        32 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 32 * devicePixelRatio; // same thing

    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

   GoogleMapController? _controller;

  getPlaceLocation() async {
    if (GlobalData.reportAddress.isEmpty|| !GlobalData.reportAddress.contains('&')) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        GlobalData.reportAddress =
            latitude.toString() + '&' + longitude.toString();
      });
    } else {
      setState(() {
        latitude = getLatitude(GlobalData.reportAddress);
        longitude = getLongitude(GlobalData.reportAddress);
      });
    }
    setState(() {
      latlong = new LatLng(latitude, longitude);
      _cameraPosition = CameraPosition(target: latlong!, zoom: 16.0);
      if (_controller != null)
        _controller!
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
      _markers.add(Marker(
          markerId: MarkerId("a"),
          draggable: true,
          position: latlong!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          onDragEnd: (_currentlatLng) {
            latlong = _currentlatLng;
          }));
    });
    locationController.text =
        await getCurrentAddress(latitude, longitude, context);
  }

//   getLocation() async {
//     setState(() {
// //      latlong=new LatLng(position.latitude, position.longitude);
//       latlong = new LatLng(latitude, longitude);
//       _cameraPosition = CameraPosition(target: latlong, zoom: 16.0);
//       if (_controller != null)
//         _controller
//             .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
//       _markers.add(Marker(
//           markerId: MarkerId("a"),
//           draggable: true,
//           position: latlong,
//           icon: _deselectedMarkerImage,
//           onDragEnd: (_currentlatLng) {
//             latlong = _currentlatLng;
//           }));
//     });
//     locationController.text =
//     await getCurrentAddress(latitude, longitude, context);
//   }

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
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 16.0,
                ),
                // initialCameraPosition: _cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller = (controller);
                  _controller!.animateCamera(
                      CameraUpdate.newCameraPosition(_cameraPosition));
                },
                onTap: (LatLng pos) {
                  setState(() {
                    latitude = pos.latitude;
                    longitude = pos.longitude;
                    GlobalData.reportAddress =
                        latitude.toString() + '&' + longitude.toString();
                    print('**********************8');
                    print(GlobalData.reportAddress);
                    print('**********************8');
                    getPlaceLocation();
                  });
                },
                markers: _markers,
                // buildingsEnabled: true,
                // mapToolbarEnabled: false,
                //
                // zoomControlsEnabled: false,
                // compassEnabled: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 160,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
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
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSvgView(
                        imageUrl: GlobalData.mapPinStrokeSvg,
                        isFromAssets: true,
                        height: 13,
                        width: 13,
                        svgColor: AppColors.text_900,
                      ),
                      SizedBox(width: 5),
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
                            Expanded(
                            child:Text('${snapshot.data}',
                                      style: TextStyle(
                                        color: AppColors.text_900,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: false),)
                                ]),
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                Row(children: <Widget>[
                                  Text(
                                    'Not Found Address',
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
                  ),
                  SizedBox(height: 10),
                  CustomSearchbar(
                    hintText: 'Search',
                    onSearchActionTap: () {},
                  ),
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
                    Text(
                      'Location',
                      maxLines: 4,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: AppColors.black.withOpacity(.9)),
                    ),
                  ]),
                  SpaceH10(),
                  Divider(
                    color: AppColors.grey.withOpacity(.2),
                    height: 3,
                    thickness: 1,
                  ),
                  SpaceH10(),
                  Container(
                    height: 50,
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
                                    'Not Found Address',
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
                  SpaceH10(),
                  Container(
                    color: AppColors.primary.withOpacity(1),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .2),
                    child: InkWell(
                      onTap: () async {
                        GlobalData.reportAddress =
                            GlobalData.reportAddress;
                        Navigator.pop(context,GlobalData.reportAddress);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Address Confirmation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: 0.0,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

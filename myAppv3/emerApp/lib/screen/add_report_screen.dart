import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:Emergency/api/database.dart';

import 'package:Emergency/model/reports.dart';

import 'package:Emergency/values/colors.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../util/global_data.dart';
import '../util/language_constants.dart';
import '../util/project_function.dart';
import '../values/spaces.dart';
import '../widget/GradientSnackBar.dart';
import '../widget/global_wedgit.dart';
import 'add_report_location.dart';
import 'home_screen.dart';

class AddReportScreen extends StatefulWidget {
  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen>
    with TickerProviderStateMixin {
  Reports? reportDetails;
  TextEditingController? reportDesc;
  TextEditingController? locationControl;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool checkValidation = false;
  String lastTap = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String location = '';
  String reportNum = '';
  Random randomGenerator = Random();
  List<XFile>? _images;

  String? _error;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    location = GlobalData.reportAddress;
  }

  @override
  void initState() {
    getCurrentLocation();
    reportDetails = Reports(
      reportId: '',
      cateName: GlobalData.cateName,
      userId: GlobalData.currentUser.uid,
      reportName: GlobalData.reportName,
      reportDesc: '',
      reportAddress: GlobalData.reportAddress,
      requestDate: DateTime.now(),
      reportStatus: '',
      requestImage: [],
    );

    location = GlobalData.reportAddress;
    locationControl = new TextEditingController();
    reportDesc = new TextEditingController();
    super.initState();
  }

  Future<String> _saveImage(XFile _image) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'reportImages/${DateTime.now().millisecondsSinceEpoch.toString()}_${getName(_image.path)}');
    await storageReference.putFile(File(_image.path));
    return await storageReference.getDownloadURL();
  }

  Future save() async {
    if (_images != null&&_images!.length!=0) {
      await Future.forEach<XFile>(_images!, (asset) async {
        String downloadUrl = await _saveImage(asset);
        reportDetails!.requestImage!.add(downloadUrl);
      });
    }
    await DatabaseService(uid: '').addReportData(reportDetails!);
  }

  void addNewReport(BuildContext context) async {                                 //
    if (location.isEmpty) {
      GradientSnackBar.showError(context, 'Please select address');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      reportDetails!.userId = GlobalData.currentUser.uid;
      reportNum= (randomGenerator.nextInt(600000) + 100000).toString();
      reportDetails!.reportNum =reportNum;
      reportDetails!.cateName = GlobalData.cateName;
      reportDetails!.reportName = GlobalData.reportName;
      reportDetails!.reportDesc = reportDesc!.text;
      reportDetails!.reportStatus = 'pending';
      reportDetails!.responseLocation = '';
      reportDetails!.responseTime = '';
      reportDetails!.accessTime = '';
      reportDetails!.completeTime = '';

      reportDetails!.reportAddress = location;
      reportDetails!.requestDate = DateTime.tryParse(
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()));
      await save();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen(initialIndex: 2,)));
    } on HttpException catch (error) {
      print(error.toString());
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, error.message);
      return;
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GradientSnackBar.showError(context, error.toString());
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }
  bool checkLocation = false;
  LatLng? latlong;

  Set<Marker> _markers = {};
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;

  getLocation() async {
    if (location.isEmpty) {
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
        latitude = getLatitude(location);
        longitude = getLongitude(location);
      });
    }
    setState(() {
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

  Widget appBar(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.only(top: 30, bottom: 5),
        margin: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(color: AppColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: InkWell(
                  onTap: () {
                    goBack(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 30,
                  ),
                )),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    getTranslated(context, 'reportDetails'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 30,
                  ),
                  onTap: () {
                    addNewReport(context);
                    //goBack();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTitel(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: <Widget>[
        Icon(
          icon,
          color: AppColors.primary,
          size: 25,
        ),
        SpaceW4(),
        Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: AppColors.black.withOpacity(.8)),
        )
      ]),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context, true);
  }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,

  );
  Completer<GoogleMapController> _controller1 = Completer();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
      color: AppColors.transparent,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: _body(),
    ));
    //
  }

  Widget _buildLocation(String? value1) {

    return Text(
      value1!,
      maxLines: 1,
      overflow: TextOverflow.clip,
      softWrap: true,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12.0,
          color: AppColors.black.withOpacity(.7)),
    );
  }
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    if (await Permission.location.isGranted) {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddReportLocation(),
          ));
      if(result!=null)
      setState(() {
        location=result;
        getLocation();
      });

    } else {
      GradientSnackBar.showError(
          context, 'Please allow the app to access the location');
      PermissionStatus status = await Permission.location.status;
      PermissionStatus p = await Permission.location.request();
      if (!p.isGranted) {
        print('no location permission to use location');
        return;
      }
    }
  }

  Widget _body() {
    Size size = MediaQuery.of(context).size;

    return Container(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      appBar(context),
      SpaceH16(),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Icon(
                Icons.assignment,
                color: AppColors.primary,
                size: 25,
              ),
              SpaceW4(),
              Row(children: <Widget>[
                Text(
                  getTranslated(context, 'reportOn') ,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: AppColors.black.withOpacity(.9)),
                ),
                SpaceW4(),
                Text(
                  getTranslated(context, reportDetails!.cateName!),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: AppColors.primary.withOpacity(1)),
                ),
              ]),

            ]),
            SpaceH10(),
          ])),
      SpaceH10(),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.assignment,
                        color: AppColors.primary,
                        size: 25,
                      ),
                      SpaceW4(),
                      Row(children: <Widget>[
                        Text(
                          getTranslated(context, 'emergencyIs') ,
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
                          getTranslated(context, reportDetails!.reportName!),
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: AppColors.primary.withOpacity(1)),
                        ),
                      ]),

                    ]),
                    SpaceH10(),
                    Divider(
                      color: AppColors.grey.withOpacity(.1),
                      height: 3,
                      thickness: 1,
                    ),
                  ])),
              SpaceH10(),
      Container(
          child: Column(children: <Widget>[
        getTitel(Icons.map_rounded, getTranslated(context, 'location')),
        SpaceH8(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: <Widget>[
            Icon(
              Icons.add_location_alt,
              color: AppColors.primary,
              size: 25,
            ),
            SpaceW4(),
            location.isEmpty
                ?
                // _buildLocation( getTranslated(context, 'notFoundAddress'))
                _buildLocation('notFoundAddress')
                : Expanded(
                    child: FutureBuilder<String>(
                    future: getCurrentAddress(
                        getLatitude(location),
                        getLongitude(location),
                        context),
                    // a previously-obtained Future<String> or null
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasData) {
                        children = <Widget>[_buildLocation('${snapshot.data}')];
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          // _buildLocation( getTranslated(context, 'notFoundAddress'))
                          _buildLocation('notFoundAddress')
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
            InkWell(
                onTap: () async {
                  _awaitReturnValueFromSecondScreen(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 1),
                  // height: 20,
                  // width: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(1),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.2),
                        offset: const Offset(1.2, 1.2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Icon(
                    Icons.add_location_sharp,
                    color: AppColors.white,
                    size: 25,
                  ),
                ))
          ]),
        ),

            FutureBuilder<String>(
              future: getCurrentAddress(
                  getLatitude(GlobalData.reportAddress),
                  getLongitude(GlobalData.reportAddress),
                  context),
              // a previously-obtained Future<String> or null
              builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    Container(
              margin:
              EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              width: size.width,
              height: size.height * .3,
              child: GoogleMap(
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: latlong!,
                  zoom: 16.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller = (controller);
                  _controller!.animateCamera(
                      CameraUpdate.newCameraPosition(_cameraPosition!));
                },
                markers: _markers,
              ),
            ),

                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    // _buildLocation( getTranslated(context, 'notFoundAddress'))
                    _buildLocation('notFoundAddress')
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

        SpaceH12(),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              color: AppColors.grey.withOpacity(.1),
              height: 3,
              thickness: 1,
            )),
      ])),
      SpaceH12(),
      Container(
          child: Column(children: <Widget>[
        SpaceH16(),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Column(
              children: [
                getTitel(Icons.post_add_outlined,
                    getTranslated(context, 'reportDesc')),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    style: TextStyle(
                      fontSize: 16,
                    ),

                    controller: reportDesc,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: getTranslated(context, 'reportDescHint'),
                      border: UnderlineInputBorder(),
                    ),
                    // validator: (String? value) {
                    //   if (value!.isEmpty) {
                    //     return 'report Description is required';
                    //   }
                    //   return null;
                    // },
                  ),
                )
              ],
            )),
      ])),
      SpaceH16(),
      Container(
          child: Column(children: <Widget>[
        getTitel(Icons.add_photo_alternate,
            getTranslated(context, 'reportPictures')),
      ])),
      SpaceH16(),
      Container(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: _buildImageRow(),
          )),
      SpaceH16(),
      if (_isLoading)
        SpinKitPianoWave(
          color: Theme.of(context).colorScheme.primary,
        )
      else
        InkWell(
          onTap: () async {
            addNewReport(context);
          },
          child: Container(
            color: AppColors.primary,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .2),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              child: Text(
                getTranslated(context, 'submitReport'),
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
      SpaceH16(),
    ])));
  }


  void _openCamera(BuildContext context) async {
    String? error;
    final ImagePicker picker = ImagePicker();
    var image;
    try {
      image = await picker.pickImage(
        source: ImageSource.camera,
        // imageQuality: 50,
        // maxWidth: 150,
      );
    } on PlatformException catch (e) {
      error = e.message!;
    }
    if (!mounted) return;
    setState(() {
      if (image != null) {
        setState(() {
          _images!.add(image);
        });
      }
      if (error != null) _error = error;
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    String? error;
    final ImagePicker imgpicker = ImagePicker();
    List<XFile>? pickedfiles;
    try {
      pickedfiles = await imgpicker.pickMultiImage();
    } on PlatformException catch (e) {
      error = e.message!;
    }
    if (!mounted) return;
    setState(() {
      if (pickedfiles != null) {
        setState(() {
          _images = pickedfiles;
        });
      }
      if (error != null) _error = error;
    });
    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  Widget _buildImageRow() {
    if (_error != null && _error!.isNotEmpty) {
      return Text(_error!);
    }

    if (_images == null || _images!.length == 0) {
      return OutlinedButton(
        onPressed: () async {
          await _showChoiceDialog(context);
        },
        child: Icon(Icons.camera_alt_outlined),
      );
    }

    return SingleChildScrollView(
        scrollDirection : Axis.horizontal,
        child:Row(
          children: List.generate(
            _images!.length,
                (index) {
              XFile asset = _images![index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: _buildImageThumb(asset, index),
              );
            },
          )..add(
            GestureDetector(
              onTap: () async {
                await _showChoiceDialog(context);
              },
              // onTap: _loadAssets,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                ),
                child: Icon(Icons.camera_alt_outlined),
              ),
            ),
          ),
        ));
  }

  Widget _buildImageThumb(XFile asset, int index) {
    ImageProvider profileImage = Image.file(File(asset.path)).image;
    return Stack(
      children: <Widget>[
        Image.file(
          File(asset.path),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 5,
          top: 5,
          child: InkWell(
            child: Icon(
              Icons.remove_circle,
              size: 20,
              color: Colors.red,
            ),
            onTap: () {
              setState(() {
                _images!.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
}

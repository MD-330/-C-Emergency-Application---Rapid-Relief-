import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_gmaps/.env.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    print('&&&&&&&&&&*******************************');
    print('${origin.latitude},${origin.longitude}');
    print('${destination.latitude},${destination.longitude}');
    print('&&&&&&&&&&*******************************');

    final response = await _dio.get(
      //AIzaSyDf5GmOWGjc3gBqOAqhVjH5VhU2CZPa-eI
      //AIzaSyA0EyCYsBZLpGjk5j3W23OzfnfPjqZP2LE
      //AIzaSyCGShAceyIm1LHL2mLja0eKCKDjoZV2RzY
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyBv0LapBO1YRM_pubjfwcHA_1HsadzjNw8',
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}

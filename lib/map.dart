import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:flutter/rendering.dart';

//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

//Author: Temi

class HomeMap extends StatefulWidget {
  HomeMap({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Map createState() => new _Map();
}

  var longitude;
  var lattitude;
  var area;

  String addtolookup = "151 Nearna Drive, Oshawa, ON";
  String testaddress;

class _Map extends State<HomeMap> {
 
  final path = [LatLng(43.9457842,-78.893896), LatLng(43.9437842,-78.897896), LatLng(43.9457842,-78.895896)];
  var _geolocator = Geolocator();
  var _positionMessage = '';

  
  

  void _updateLocation(userLocation) {
    // geolocator plug-in:
    setState(() {
      _positionMessage = userLocation.latitude.toString() + ', ' + userLocation.longitude.toString();
    });
    print('New location: ${userLocation.latitude}, ${userLocation.longitude}.');

    // test out reverse geocoding
    _geolocator.placemarkFromCoordinates(userLocation.latitude, userLocation.longitude).then((List<Placemark> places) {
      print('Reverse geocoding results:');
      for (Placemark place in places) {
        print('\t${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}');
      }
    });
    
    // testing out forward geocoding
    //String address = '151 Nearna Drive, Oshawa, ON';
    _geolocator.placemarkFromAddress(testaddress).then((List<Placemark> places) {
      print('Forward geocoding results:');
      for (Placemark place in places) {
         area = place.position;
         longitude = area.longitude;
         lattitude = area.latitude;
        print('\t${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}, ${area}');
      }
    });

     
  }
  
  @override 
  void initState() {
    // geolocator plug-in version:
    _geolocator.checkGeolocationPermissionStatus().then((GeolocationStatus geolocationStatus) {
      print('Geolocation status: $geolocationStatus.');
    });

    _geolocator.getPositionStream(LocationOptions(accuracy: LocationAccuracy.best, timeInterval: 5000))
      .listen((userLocation) {
        _updateLocation(userLocation);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("My location"),
      ),
      body: lattitude == null ? loading() : map(),
    );
  }

  Widget loading()
  {
    return Center(
        child: SpinKitRotatingCircle(
          color: Colors.orange,
          size: 200.0
        ),
      );
  }


  Widget map()
  {
    final centre = LatLng(lattitude,longitude);
    return FlutterMap(
        options: MapOptions(
          minZoom: 16.0,
          center: centre,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://api.mapbox.com/styles/v1/rfortier/cjzcobx1x2csf1cmppuyzj5ys/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmZvcnRpZXIiLCJhIjoiY2p6Y282cWV4MDg0ZDNibG9zdWZ6M3YzciJ9.p1ePjCH-zs0RdBbLx40pgQ',
            additionalOptions: {
              'accessToken': 'pk.eyJ1IjoicmZvcnRpZXIiLCJhIjoiY2p6Y282cWV4MDg0ZDNibG9zdWZ6M3YzciJ9.p1ePjCH-zs0RdBbLx40pgQ',
              'id': 'mapbox.mapbox-streets-v8'
            }
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 45.0,
                height: 45.0,
                point: centre,
                builder: (context) => Container(
                  child: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.blue,
                    iconSize: 45.0,
                    onPressed: () {
                      print('Icon clicked');
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      );
  }
}
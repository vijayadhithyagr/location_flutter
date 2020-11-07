import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class Location extends StatefulWidget {
  final String name;
  Location({this.name});
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locater'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Hello ${widget.name}',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),

            OutlineButton(
              child: Text('Get Location'),
              onPressed: (){
                _getCurrentLocation();
              },
            ),
            if (_currentPosition != null)
              Text(_currentAddress),
          ],
        ),
      ),
    );
  }
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}


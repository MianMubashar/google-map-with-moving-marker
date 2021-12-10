import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier{
  double? _latitude;
  double? _longitude;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  initializer() async{
    await getLocation();
  }
  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      print("Location service is not enabled");
    }
    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');

      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');

    }

    Position position=await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

      _latitude=position.latitude;
      _longitude=position.longitude;
      print("Latitude ${_latitude}");
      print("Longitude ${_longitude}");
      addMarker(1, LatLng(position.latitude, position.longitude));
      notifyListeners();
  }

  addMarker(int value, LatLng position) {
    MarkerId markerId = MarkerId(value.toString());

      Marker marker = Marker(
          markerId: markerId,
          position: position,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
              title: 'Position',
              snippet: '${position.latitude} ${position.longitude}'));
      markers[markerId] = marker;

  }

  double? get latitude=>_latitude;
  double? get longitude=>_longitude;
  Map<MarkerId,Marker> get markers=>_markers;


}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_integration/provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleMapController? googleMapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initializer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: googleMapUI()),
    );
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(builder: (context, model, child) {
      if (model.latitude == null && model.longitude == null) {
        return Container(child: Center(child: CircularProgressIndicator()));
      } else {
        return GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          initialCameraPosition: CameraPosition(
              target: LatLng(model.latitude!, model.longitude!), zoom: 15),
          markers: Set<Marker>.of(model.markers.values),
          onCameraMove: (cameraPosition) {
            print(
                "camera position ${cameraPosition.target.latitude}     ${cameraPosition.target.longitude}");
            setState(() {
              model.addMarker(
                  1,
                  LatLng(cameraPosition.target.latitude,
                      cameraPosition.target.longitude));
            });
            googleMapController!.showMarkerInfoWindow(MarkerId('1'));
          },
        );
      }
    });
  }
}

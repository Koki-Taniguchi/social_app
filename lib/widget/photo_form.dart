import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/context/arguments/to_home_arguments.dart';
import 'package:social_picture/http_services/photo_client.dart';
import 'package:social_picture/models/entities/photo.dart';

class PhotoFrom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.mail,
                          color: Colors.black45,
                        ),
                        title: TextFormField()),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Colors.black45,
                        ),
                        title: TextFormField(
                          obscureText: true,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CameraPosition> _goToCurrentPosition() async {
    Position _currentPosition =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    CameraPosition _currentCameraPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 20.0);
    return _currentCameraPosition;
  }

  Future<List<Photo>> _getNearbyPhotos() async {
    Map<String, dynamic> res = await PhotoClient.get();
    return Photo.fromJsonArray(res);
  }

  void goToHomePage(context) async {
    CameraPosition _currentCameraPosition = await _goToCurrentPosition();
    List<Photo> _photos = await _getNearbyPhotos();
    await Navigator.of(context)
        .pushReplacementNamed('/home', arguments: ToHomeArguments(_currentCameraPosition, _photos));
  }
}

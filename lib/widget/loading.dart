import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/context/arguments/to_home_arguments.dart';
import 'package:social_picture/http_services/photo_client.dart';
import 'package:social_picture/models/entities/photo.dart';

class Loading extends StatefulWidget {
  final RouteObserver<PageRoute> routeObserver;
  Loading(this.routeObserver);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    goToHomePage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 200.0,
          width: 200.0,
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
    await Navigator.of(context).pushReplacementNamed('/home',
        arguments: ToHomeArguments(_currentCameraPosition, _photos));
  }
}

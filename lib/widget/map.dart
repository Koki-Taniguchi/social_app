import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/context/arguments/to_home_arguments.dart';
import '../models/entities/photo.dart';
import 'page_view.dart';

class MapApp extends StatefulWidget {
  @override
  State<MapApp> createState() => MapAppState();
}

class MapAppState extends State<MapApp> {
  @override
  Widget build(BuildContext context) {
    ToHomeArguments arguments = ModalRoute.of(context).settings.arguments;
    PhotoSlider slider = PhotoSlider(pages: Photo.toWidgets(arguments.photos));

    return new Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: arguments.currentCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  slider.mapComplete(controller);
                },
                markers: Photo.toMarkers(arguments.photos)),
            SizedBox(
              height: 150.0,
              child: slider,
            )
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 150.0),
          child: FloatingActionButton(
            onPressed: showPostForm,
            child: Icon(Icons.add_a_photo),
            // child: Icon(Icons.add_a_photo),
          ),
        ));
  }

  void showPostForm() async {
    await Navigator.of(context).pushReplacementNamed('/photoForm');
  }
}

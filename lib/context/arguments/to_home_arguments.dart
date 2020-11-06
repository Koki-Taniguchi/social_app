import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/models/entities/photo.dart';

class ToHomeArguments {
  final CameraPosition currentCameraPosition;
  final List<Photo> photos;

  ToHomeArguments(this.currentCameraPosition, this.photos);
}

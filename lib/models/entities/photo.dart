import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/widget/photo_widget_box.dart';

class Photo {
  final String id;
  final String title;
  final String image; // ImageURL
  final double latitude;
  final double longitude;

  static List<Photo> fromJsonArray(Map<String, dynamic> json) {
    List<Photo> photoList = [];
    json['photos'].forEach((j) => photoList.add(Photo.fromJson(j)));
    return photoList;
  }

  static List<PhotoWidgetBox> toWidgets(List<Photo> photos) {
    List<PhotoWidgetBox> widgets = [];
    photos.forEach((photo) {
      widgets.add(PhotoWidgetBox(photo));
    });

    return widgets;
  }

  static Set<Marker> toMarkers(List<Photo> photos) {
    Set<Marker> markers = {};
    photos.forEach((photo) {
      markers.add(photo.toMarker());
    });

    return markers;
  }

  Photo(this.id, this.title, this.image, this.latitude, this.longitude);

  Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        image = json['image'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'latitude': latitude,
        'longitude': longitude
      };

  LatLng toLatLng() {
    return LatLng(this.latitude, this.longitude);
  }

  Marker toMarker() {
    return Marker(
      markerId: MarkerId(this.id),
      position: this.toLatLng(),
      infoWindow: InfoWindow(
        title: this.title,
      ),
    );
  }
}

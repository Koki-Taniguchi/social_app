import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_picture/widget/photo_widget_box.dart';

class Photo {
  final String id;
  final String title;
  final String image; // ImageURL
  final double latitude;
  final double longitude;

  static Map<String, dynamic> testDataJson1() {
    return {
      'id': 'photo1',
      'title': 'photoTitle1',
      'image':
          'https://mortimerland.com/blog-corporate-branding-designers/wp-content/uploads/2015/07/graphic-design-on-street-art-1.png',
      'latitude': 35.6583865,
      'longitude': 139.7023339
    };
  }

  static Map<String, dynamic> testDataJson2() {
    return {
      'id': 'photo2',
      'title': 'photoTitle2',
      'image':
          'https://we-j.jp/wp-content/uploads/2020/07/We%E4%B8%96%E7%95%8C%E4%B8%AD%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%81-1.png',
      'latitude': 35.658319,
      'longitude': 139.702232
    };
  }

  static List<Photo> testDataList() {
    return <Photo>[
      Photo.fromJson(Photo.testDataJson1()),
      Photo.fromJson(Photo.testDataJson2())
    ];
  }

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_picture/context/arguments/to_home_arguments.dart';

import 'package:social_picture/http_services/photo_client.dart';
import 'package:social_picture/models/entities/photo.dart';
import 'package:social_picture/models/uploader/image_uploader.dart';

class PhotoFrom extends StatefulWidget {
  @override
  _PhotoFromState createState() => _PhotoFromState();
}

class _PhotoFromState extends State<PhotoFrom> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  String choseImage;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "タイトルを入力してください";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "タイトル",
                            hintText: "ex. SHIBUYA SKYからの夜景"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (choseImage != null)
                            Text("画像選択済み")
                          else
                            Text(
                              "画像を選択してください",
                              style: TextStyle(color: Colors.red),
                            ),
                          RaisedButton(
                            child: Text('画像選択'),
                            onPressed: () {
                              showBottomSheet();
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 30,
                            ),
                            child: RaisedButton(
                              child: Text(
                                '投稿',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.lightBlue,
                              onPressed: () {
                                upload();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() async {
    final result = await showCupertinoBottomBar();
    String imageFile;
    if (result == 0) {
      imageFile = await ImageUploader(ImageSource.camera).getImageFromDevice();
    } else if (result == 1) {
      imageFile = await ImageUploader(ImageSource.gallery).getImageFromDevice();
    }

    setState(() {
      choseImage = imageFile;
    });
  }

  void upload() async {
    if (!_formKey.currentState.validate() || choseImage == null) {
      return;
    }

    Position _currentPosition =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Photo photo = Photo(null, titleController.text, choseImage,
        _currentPosition.latitude, _currentPosition.longitude);

    PhotoClient.post(photo);
    goToHomePage(context, _currentPosition);
  }

  Future<int> showCupertinoBottomBar() {
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('写真をアップロードします'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'カメラで撮影',
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'アルバムから選択',
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, 2);
              },
              isDefaultAction: true,
            ),
          );
        });
  }

  Future<List<Photo>> _getNearbyPhotos() async {
    Map<String, dynamic> res = await PhotoClient.get();
    return Photo.fromJsonArray(res);
  }

  void goToHomePage(context, Position currentPosition) async {
    CameraPosition _currentCameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 20.0);
    List<Photo> _photos = await _getNearbyPhotos();
    await Navigator.of(context).pushReplacementNamed('/home',
        arguments: ToHomeArguments(_currentCameraPosition, _photos));
  }
}

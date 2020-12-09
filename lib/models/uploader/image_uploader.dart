import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  ImageUploader(this.source, {this.quality = 50});

  final ImageSource source;
  final int quality;

  Future<String> getImageFromDevice() async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile == null) {
      return null;
    }

    final File file = File(pickedFile.path);
    final Uint8List bytedata = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 1,
    );

    return base64Encode(bytedata);
  }
}

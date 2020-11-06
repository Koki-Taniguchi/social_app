import 'package:flutter/cupertino.dart';

import '../models/entities/photo.dart';

class PhotoWidgetBox extends StatefulWidget {
  final Photo photo;
  PhotoWidgetBox(this.photo);

  @override
  _PhotoBoxState createState() => _PhotoBoxState();
}

class _PhotoBoxState extends State<PhotoWidgetBox> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Image.network(widget.photo.image),
    );
  }
}

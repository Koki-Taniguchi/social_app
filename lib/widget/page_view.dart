import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:social_picture/models/entities/photo.dart';
import 'package:social_picture/widget/photo_widget_box.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.pageCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  final PageController controller;
  final int pageCount;
  final ValueChanged<int> onPageSelected;
  final Color color;

  static const double _kDotSize = 8.0;
  static const double _kMaxZoom = 2.0;
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(pageCount, _buildDot),
    );
  }
}

class PhotoSlider extends StatefulWidget {
  PhotoSlider({this.pages});
  final List<PhotoWidgetBox> pages;
  final Completer<GoogleMapController> googleMapController = Completer();

  @override
  State createState() =>
      PhotoSliderState(pages: pages, googleMapController: googleMapController);
  void mapComplete(GoogleMapController controller) {
    googleMapController.complete(controller);
  }
}

class PhotoSliderState extends State<PhotoSlider> {
  PhotoSliderState({this.pages, this.googleMapController});
  final List<PhotoWidgetBox> pages;
  final Completer<GoogleMapController> googleMapController;

  Photo currentPhoto;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final _controller = new PageController();
  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    googleMapController.future.then((googleMap) {
      if (currentPhoto != null) {
        googleMap
            .animateCamera(CameraUpdate.newLatLng(currentPhoto.toLatLng()));
      }
    });

    return new Scaffold(
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: Column(
          children: [
            Container(
              height: 120.0,
              child: new PageView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return pages[index % pages.length];
                },
                onPageChanged: (index) async {
                  await _showWindowForSelectedMarker(index);
                  setState(() {});
                },
              ),
            ),
            Container(
              height: 30.0,
              color: Colors.grey[800].withOpacity(0.8),
              child: new Center(
                child: new DotsIndicator(
                  controller: _controller,
                  pageCount: pages.length,
                  onPageSelected: (int page) {
                    _controller.animateToPage(
                      page,
                      duration: _kDuration,
                      curve: _kCurve,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showWindowForSelectedMarker(int index) async {
    this.currentPhoto = pages[index].photo;

    if (googleMapController.isCompleted) {
      final GoogleMapController googleMap = await googleMapController.future;
      final MarkerId selectedMarker = MarkerId(this.currentPhoto.id);
      final bool isSelectedMarkerShown =
          await googleMap.isMarkerInfoWindowShown(selectedMarker);

      if (!isSelectedMarkerShown) {
        await googleMap.showMarkerInfoWindow(selectedMarker);
      }
    }
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/image.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/align.dart';



class PictureParser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      col = getVal(data,'col');
     // colTl = getInt(getVal(col,'tl'),2);
    String colDirect = getVal(col,'direct').toString();
    double colHeight  = getDouble(getVal(col,'height'),200),
      ratio = getRatio(getVal(data,'ratio'));

    if(par['gallery'] is List) {
      List<dynamic> gallery = par['gallery'];
      List<Widget> photo = [];
      if(gallery.length > 0) {
        gallery.forEach((v) {
          Widget img = getImageRatio(v,'t',ratio);
          if(img != null) {
            photo.add(img);
            photo.add(img);
            photo.add(img);
            photo.add(img);
            photo.add(img);
            photo.add(img);
          }
        });
      }
      if(photo.length > 0) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {       
            double width = min(viewportConstraints.maxWidth , 450);
            double height = width * (ratio > 0 ? ratio : 1);
            return Container(
              constraints: BoxConstraints(maxWidth: width),
              decoration: BoxDecoration(
                gradient: getGradient(getVal(box,'bg.color')),
                borderRadius: getBorderRadius(getVal(box,'border')),
                boxShadow: getBoxShadow(getVal(box,'shadow')),
              ),
              margin: getEdgeInset(getVal(box,'margin')),
              //padding: getEdgeInset(getVal(box,'padding')),
              alignment: getAlignBox(getVal(data,'align')),
              //width: double.infinity,
              height: height,
              child: CustomPaint(
                //size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
                painter: DrawCurve(getVal(box,'bg.color')),
                child: Container(
                  padding: getEdgeInset(getVal(box,'padding')),
                  child: ImageSliderWidget(imageUrls: photo, imageHeight: height)
                )
              )
            );
          }
        );
      }
    }
    return Container();
  }
  
  @override
  String get widgetName => 'picture';
}



class ImageSliderWidget extends StatefulWidget {
  final List<Widget> imageUrls;
  final double imageHeight;

  const ImageSliderWidget({
    Key key,
    @required this.imageUrls,
    this.imageHeight = 350.0,
  }) : super(key: key);

  @override
  ImageSliderWidgetState createState() {
    return ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<Widget> _pages = [];

  int page = 0;

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      //height: widget.imageHeight,
      padding: EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 0,
        child: Stack(
          children: [
            _buildPagerViewSlider(),
            _buildDotsIndicatorOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (int p) {
          setState(() {
            page = p;
          });
        },
      ),
    );
  }

  Positioned _buildDotsIndicatorOverlay() {
    return Positioned(
      bottom: 10.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotsIndicator(
          controller: _controller,
          itemCount: _pages.length,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 4.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 15.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
//        1.0 -  (controller.hasClients ?  ( ((controller.page ?? controller.initialPage) - index).abs()) : 0),
        1.0 -  ((controller.page ?? controller.initialPage) - index).abs(),
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
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
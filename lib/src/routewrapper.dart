import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imagex/src/item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageXRouteWrapper extends StatefulWidget {
  ImageXRouteWrapper({
    super.key,
    this.initialIndex = 0,
    required this.items,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<ImageXItem> items;

  @override
  State<StatefulWidget> createState() {
    return _ImageXRouteWrapperState();
  }
}

class _ImageXRouteWrapperState extends State<ImageXRouteWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  double? initialPositionY = 0;

  double? currentPositionY = 0;

  double positionYDelta = 0;

  double opacity = 1;

  double disposeLimit = 300;

  late Duration animationDuration;

  void setZoomed(bool zoomed) {
    setState(() {
      isZoomed = zoomed;
    });
  }

  @override
  void initState() {
    super.initState();
    animationDuration = Duration.zero;
  }

  void _startVerticalDrag(details) {
    setState(() {
      initialPositionY = details.globalPosition.dy;
    });
  }

  void _whileVerticalDrag(details) {
    setState(() {
      currentPositionY = details.globalPosition.dy;
      positionYDelta = currentPositionY! - initialPositionY!;
      setOpacity();
    });
  }

  setOpacity() {
    double tmp = positionYDelta < 0
        ? 1 - ((positionYDelta / 1000) * -1)
        : 1 - (positionYDelta / 1000);
    if (tmp > 1) {
      opacity = 1;
    } else if (tmp < 0) {
      opacity = 0;
    } else {
      opacity = tmp;
    }

    if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
      opacity = 0.0;
    }
  }

  _endVerticalDrag(DragEndDetails details) {
    if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        animationDuration = Duration(milliseconds: 300);
        opacity = 1;
        positionYDelta = 0;
      });

      Future.delayed(animationDuration).then((_) {
        setState(() {
          animationDuration = Duration.zero;
        });
      });
    }
  }

  int _pointersOnScreen = 0;
  bool isLocked = false;
  bool isZoomed = false;
  @override
  Widget build(BuildContext context) {
    final isSingle = widget.items.length == 1;
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: isSingle
              ? null
              : Text("${currentIndex + 1}/${widget.items.length}"),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Listener(
            onPointerDown: (event) {
              _pointersOnScreen++;
              setState(() => isLocked = _pointersOnScreen >= 2);
            },
            onPointerUp: (event) => _pointersOnScreen--,
            child: GestureDetector(
                onVerticalDragStart: (details) =>
                    isLocked || isZoomed ? null : _startVerticalDrag(details),
                onVerticalDragUpdate: (details) =>
                    isLocked || isZoomed ? null : _whileVerticalDrag(details),
                onVerticalDragEnd: (details) =>
                    isLocked || isZoomed ? null : _endVerticalDrag(details),
                child: Container(
                  color: Colors.black.withOpacity(opacity),
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                  ),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0)),
                    constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        AnimatedPositioned(
                          duration: animationDuration,
                          curve: Curves.fastOutSlowIn,
                          top: 0 + positionYDelta,
                          bottom: 0 - positionYDelta,
                          left: 0,
                          right: 0,
                          child: PhotoViewGallery.builder(
                            scrollPhysics: const BouncingScrollPhysics(),
                            builder: _buildItem,
                            itemCount: widget.items.length,
                            backgroundDecoration: BoxDecoration(
                                color: Colors.black.withOpacity(0)),
                            pageController: widget.pageController,
                            onPageChanged: onPageChanged,
                          ),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final ImageXItem item = widget.items[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: item.isAsset
          ? Image.asset(item.resource).image
          : CachedNetworkImageProvider(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5),
      maxScale: PhotoViewComputedScale.covered * 2,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

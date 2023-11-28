import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photox/src/dismissmode.dart';
import 'package:photox/src/item.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoxRouteWrapper extends StatefulWidget {
  PhotoxRouteWrapper(
      {super.key,
      this.initialIndex = 0,
      required this.items,
      this.appBarLeadingWidget,
      this.titleTextStyle,
      this.dismissMode = DismissMode.swipeAny})
      : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<PhotoXItem> items;
  final DismissMode dismissMode;
  final TextStyle? titleTextStyle;
  final Widget? appBarLeadingWidget;

  @override
  State<StatefulWidget> createState() {
    return _PhotoxRouteWrapperState();
  }
}

class _PhotoxRouteWrapperState extends State<PhotoxRouteWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  double? initialPositionY = 0;
  double? initialPositionX = 0;

  double? currentPositionY = 0;
  double? currentPositionX = 0;

  double positionYDelta = 0;
  double positionXDelta = 0;

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

  void _pointerDown(PointerDownEvent event) {
    setState(() {
      initialPositionY = event.position.dy;
      initialPositionX = event.position.dx;
    });
  }

  void _pointerMove(PointerMoveEvent event) {
    setState(() {
      currentPositionY = event.position.dy;
      positionYDelta = currentPositionY! - initialPositionY!;

      currentPositionX = event.position.dx;
      positionXDelta = currentPositionX! - initialPositionX!;
      setOpacity();
    });
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
    double tmp = widget.dismissMode == DismissMode.swipeAny
        ? min(positionYDelta, positionXDelta) < 0
            ? 1 - ((min(positionYDelta, positionXDelta) / 1000) * -1)
            : 1 - (max(positionYDelta, positionXDelta) / 1000)
        : positionYDelta < 0
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
        animationDuration = const Duration(milliseconds: 300);
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
          leading: widget.appBarLeadingWidget ??
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
          elevation: 0,
          centerTitle: true,
          title: isSingle
              ? null
              : Text(
                  "${currentIndex + 1}/${widget.items.length}",
                  style: widget.titleTextStyle,
                ),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Listener(
                onPointerMove: (event) =>
                    widget.dismissMode == DismissMode.swipeAny &&
                            !isLocked &&
                            !isZoomed
                        ? _pointerMove(event)
                        : null,
                onPointerDown: (event) {
                  _pointersOnScreen++;
                  setState(() => isLocked = _pointersOnScreen >= 2);
                  if (widget.dismissMode == DismissMode.swipeAny &&
                      !isLocked &&
                      !isZoomed) {
                    _pointerDown(event);
                  }
                },
                onPointerUp: (event) {
                  _pointersOnScreen--;
                  if (widget.dismissMode == DismissMode.swipeAny &&
                      !isLocked &&
                      !isZoomed) {
                    if (positionYDelta > disposeLimit ||
                        positionYDelta < -disposeLimit ||
                        positionXDelta > disposeLimit ||
                        positionXDelta < -disposeLimit) {
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        animationDuration = const Duration(milliseconds: 300);
                        opacity = 1;
                        positionYDelta = 0;
                        positionXDelta = 0;
                      });

                      Future.delayed(animationDuration).then((_) {
                        setState(() {
                          animationDuration = Duration.zero;
                        });
                      });
                    }
                  }
                },
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragStart: (details) =>
                        widget.dismissMode == DismissMode.swipeAny ||
                                isLocked ||
                                isZoomed
                            ? null
                            : _startVerticalDrag(details),
                    onVerticalDragUpdate: (details) =>
                        widget.dismissMode == DismissMode.swipeAny ||
                                isLocked ||
                                isZoomed
                            ? null
                            : _whileVerticalDrag(details),
                    onVerticalDragEnd: (details) =>
                        widget.dismissMode == DismissMode.swipeAny ||
                                isLocked ||
                                isZoomed
                            ? null
                            : _endVerticalDrag(details),
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
                              left: 0 + positionXDelta,
                              right: 0 - positionXDelta,
                              child: PhotoViewGallery.builder(
                                scrollPhysics: widget.items.length == 1
                                    ? const NeverScrollableScrollPhysics()
                                    : const BouncingScrollPhysics(),
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
                    ))),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        stops: [0.25, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
            )
          ],
        ));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final PhotoXItem item = widget.items[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: item.isAsset
          ? Image.asset(item.resource).image
          : CachedNetworkImageProvider(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

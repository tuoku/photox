import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photox/src/item.dart';

class PhotoxThumbnail extends StatelessWidget {
  const PhotoxThumbnail({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final PhotoxItem item;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      //padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: item.id,
          child: item.isAsset
              ? Image.asset(item.resource)
              : CachedNetworkImage(
                  imageUrl: item.resource,
                  fit: BoxFit.cover,
                  //height: 80.0,
                ),
        ),
      ),
    );
  }
}

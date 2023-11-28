import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator(
      {required this.length,
      required this.position,
      required this.activeColor,
      required this.backgroundColor,
      required this.bubblePadding,
      required this.bubbleRadius,
      required this.inactiveColor,
      super.key});

  final int length;
  final int position;
  final double bubbleRadius;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsetsGeometry bubblePadding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
            length,
            (index) => Padding(
                padding: bubblePadding,
                child: Container(
                  height: bubbleRadius,
                  width: bubbleRadius,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == position ? activeColor : inactiveColor),
                ))),
      ),
    );
  }
}

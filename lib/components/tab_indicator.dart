import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  Color color;
  CustomTabIndicator({required this.color}) : super();
  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) =>
      _CustomPainter(this, onChanged);
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = Rect.fromLTWH(
        configuration.size!.width / 2 + offset.dx - 35, offset.dy + 65, 75, 5);
    final Paint paint = Paint();
    paint.color = Color(0xFFFF8652);
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      paint,
    );
  }
}

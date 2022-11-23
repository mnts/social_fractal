import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:social_fractal/utils/strip_margin.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/slide.dart';

class FractalSlide extends StatelessWidget {
  SlideFractal fractal;
  FractalSlide(
    this.fractal, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 48,
          //fontFamily: 'Hind',
          shadows: [
            Shadow(
              offset: Offset(4, 4),
              blurRadius: 12,
              color: Colors.black,
            )
          ],
          color: Colors.white,
        ),
        child: ZStack([
          ClipRRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: CachedNetworkImage(
                imageUrl: fractal.backgroundUrl,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                height: height,
                width: width,
              ),
            ),
          ),
          SizedBox(
            child: VStack(
              [
                Text(
                  stripMargin(fractal.title.value),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    shadows: [
                      Shadow(
                        offset: Offset(4, 4),
                        blurRadius: 12,
                        color: Colors.black,
                      )
                    ],
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 26,
                  ),
                  height: 300,
                  width: 600,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(171, 179, 179, 179),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Markdown(
                    data: fractal.text,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            ),
            width: width,
            height: height,
          ),
        ]),
      ),
    );
  }
}
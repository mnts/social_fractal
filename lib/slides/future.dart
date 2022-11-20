import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_fractal/utils/strip_margin.dart';

class FutureSlide extends StatefulWidget {
  FutureSlide({Key? key}) : super(key: key);
  @override
  _FutureSlideState createState() => _FutureSlideState();
}

class _FutureSlideState extends State<FutureSlide> {
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
        child: Stack(children: [
          Image.asset(
            'assets/city.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            height: height,
            width: width,
          ),
          SizedBox(
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/pineal.jpg'),
                  width: 680,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(9, 9),
                        blurStyle: BlurStyle.normal,
                        blurRadius: 16,
                      )
                    ],
                    borderRadius: BorderRadius.circular(128),
                  ),
                ),
                SizedBox(height: 64),
                ClipRRect(
                  // Clip it cleanly.
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 26,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xAB2B2B2B),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            stripMargin('Naturally Alligned Future'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 48,
                            ),
                          ),
                          Text(
                            stripMargin("""
                          For efficient timeline we need programmable medium of cooperation
                          It should constantly adapt its resonance with data from the real world
                          Decentralisation of power is essential in eliminating bottle neck effect
                          Society should not be held by slow iterations of centralised biuricracy
                          We build technology by learning from nature and its quantum principles
                          Prosperous future should be alligned with natural ecosystem.
                        """),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.2,
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            width: width,
            height: height,
          ),
        ]),
      ),
    );
  }
}

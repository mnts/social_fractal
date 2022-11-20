import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_fractal/utils/strip_margin.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeSlide extends StatefulWidget {
  HomeSlide({Key? key}) : super(key: key);
  @override
  _HomeSlideState createState() => _HomeSlideState();
}

class _HomeSlideState extends State<HomeSlide> {
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
              child: Image.asset(
                'assets/ai.png',
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
                Container(
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
                  child: VStack(
                    [
                      //Image.asset('assets/logo.png', width: 128),
                      Text(
                        stripMargin('Quantum Inteligence'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        stripMargin(
                            'Framework for decentralised - AI driven applications'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        stripMargin("""
                          Our goal is to build tools and network systems that facilitates evolutionary integrity of human consciousness.
                          We want our tools to be easily distributable, intuitive for humans with everybody owning the peace of it.
                          Eventually we gonna become a base framework for many decentralised WEB3 applications.
                        """),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                        ),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
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

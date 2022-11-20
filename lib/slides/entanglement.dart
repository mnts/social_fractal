import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:social_fractal/utils/strip_margin.dart';
import 'package:velocity_x/velocity_x.dart';

class EntanglementSlide extends StatefulWidget {
  EntanglementSlide({Key? key}) : super(key: key);
  @override
  _HomeSlideState createState() => _HomeSlideState();
}

class _HomeSlideState extends State<EntanglementSlide> {
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
                'assets/personal.png',
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
                        stripMargin('Quantum Entanglement'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        stripMargin('Life is a dream and we are the dreamers'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        stripMargin("""
                          If we keep focusing our attention on our dream life, we will eventually manifest everything needed to exist at that new frequenny.
                          Everything is energy and vibration. Our intentions is the most powerful force, when its directed towards our highest good.
                          All the forces of the universe are entangled, everythy aspect of our actions and thoughts are interferring with the whole.
                          Future and past are not separate, its a combination of all the possibilities. We can amplify specific properties of our reality with AI.
                          Our collective consciousness, earth electromagnetic fied, computational power, epigenetics are all the same entangled force.
                          Time is gravity. The more we are present in the moment, the more electromagnetic potential we materialise into our desired reality.
                          By having collectively good intentons we can always stay on flow and external forces will always be in our favour.
                          We try to distribute system in a way to embrace the entanglement priciples and together amplify the frequency of god.
                          And strengthen all that within us that is good, true and beautiful.
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

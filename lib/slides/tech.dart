import 'package:flutter/material.dart';
import 'package:social_fractal/utils/strip_margin.dart';
import 'package:velocity_x/velocity_x.dart';
import '/areas/techs.dart';

class TechSlide extends StatefulWidget {
  TechSlide({Key? key}) : super(key: key);
  @override
  _TechSlideState createState() => _TechSlideState();
}

class _TechSlideState extends State<TechSlide> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height,
        width = MediaQuery.of(context).size.width;

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
          Image.asset(
            'assets/ai.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            height: height,
            width: width,
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
                      Text(
                        stripMargin(
                            'Decentralised Technologies entangled for best traveling experience'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        stripMargin("""
                          We don't need centralised systems to manage our travel.
                          P2P payments between drivers and passangers are better.
                          All process can be logged on a blockchain to guarantee trust.
                          Also we can log into immutable storage details about route taken.
                          Helps to save money for lots of fees while traveling. 
                          Cuz we don't need to spend it on mediums.
                        """),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.2,
                        ),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  width: width,
                  child: TechsArea(),
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

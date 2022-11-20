import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:social_fractal/utils/strip_margin.dart';

import '../areas/techs.dart';

class VaxSlide extends StatefulWidget {
  VaxSlide({Key? key}) : super(key: key);
  @override
  _VaxSlideState createState() => _VaxSlideState();
}

class _VaxSlideState extends State<VaxSlide> {
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
            'assets/distributed.jpg',
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
                        stripMargin('Federated Intelligence'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        stripMargin("""
                        A distributed intelligence network that can be used to
                        solve complex problems in a decentralised manner.
                        Plus we can use AI to make the best route for the driver.
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

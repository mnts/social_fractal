import 'package:flutter/material.dart';
import 'package:social_fractal/slides/entanglement.dart';
import 'package:social_fractal/slides/home.dart';
import 'package:url_launcher/url_launcher.dart';
import '/slides/tech.dart';
import '/slides/vax.dart';

import 'slides/future.dart';

class CyberSlides extends StatefulWidget {
  CyberSlides({Key? key}) : super(key: key);

  @override
  _CyberSlidesState createState() => _CyberSlidesState();
}

class _CyberSlidesState extends State<CyberSlides> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> slides = [
      HomeSlide(),
      EntanglementSlide(),
      FutureSlide(),
      VaxSlide(),
      TechSlide(),
    ];

    return DefaultTabController(
      length: 3,
      child: TabBarView(
        //physics: BouncingScrollPhysics(),
        children: slides,
      ),
    );
  }
}

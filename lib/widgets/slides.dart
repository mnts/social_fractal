import 'package:flutter/material.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:provider/provider.dart';
import 'package:social_fractal/extensions/slides.dart';
import 'package:social_fractal/slides/entanglement.dart';
import 'package:social_fractal/slides/home.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/slide.dart';
import '../slides/slide.dart';
import '/slides/tech.dart';
import '/slides/vax.dart';

class FractalSlides extends StatefulWidget {
  FractalSlides({Key? key}) : super(key: key);

  @override
  _FractalSlidesState createState() => _FractalSlidesState();
}

class _FractalSlidesState extends State<FractalSlides> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  List<SlideFractal> slides = [];

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppFractal>(context);

    return DefaultTabController(
      length: 3,
      child: TabBarView(
        //physics: BouncingScrollPhysics(),
        children: [
          ...app.slides.map((fractal) => FractalSlide(fractal)),
        ],
      ),
    );
  }
}

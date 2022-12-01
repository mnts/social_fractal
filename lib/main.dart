import 'package:flutter/material.dart';
import 'package:fractal_gold/ui.dart';
import 'package:fractals/io.dart';
import 'app.dart';
import 'fluffy.dart';
import 'screens.dart';

void main() async {
  await FractalUI.init();
  FIO.documentsPath = '/Users/mk/Data/Documents';

  final app = SocialAppFractal(
    id: 'axio',
    color: Color.fromARGB(255, 120, 0, 133),
    icon: Image.asset('assets/logo.png'),
    title: 'SocialFractal',
    repoUrl: 'http://localhost',
    //hideAppBar: true,
    home: slidesScreen,
    server: 'gen.sale',
    description: 'Social fractal based on matrix',
    /*ScreenFractal(
    icon: Icons.picture_in_picture_outlined,
    name: 'pix8',
    builder: Pix8Screen.new,
  ),*/
    screens: [
      fluffyScreen,
      catalogScreen,
      loginScreen,
    ],
  );

  await app.initClients();

  runApp(
    SocialFractalApp(app),
  );
}

import 'package:flutter/material.dart';
import 'package:fractal_gold/auth/fractals/index.dart';
import 'package:fractal_gold/layouts/fractal.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractals/models/index.dart';

import 'screens.dart';
import 'widgets/avatar.dart';

final app = AppFractal(
  id: 'axio',
  color: Color.fromARGB(255, 120, 0, 133),
  icon: Image.asset('assets/logo.png'),
  title: 'SocialFractal',
  repoUrl: 'http://localhost',
  //hideAppBar: true,
  auths: [
    LocalAuthFractal(),
    PasswordAuthFractal(),
    MetamaskAuthFractal(),
  ],
  home: slidesScreen,
  /*ScreenFractal(
    icon: Icons.picture_in_picture_outlined,
    name: 'pix8',
    builder: Pix8Screen.new,
  ),*/
  screens: [
    fluffyScreen,
    catalogScreen,
    peopleScreen,
    loginScreen,
  ],
);

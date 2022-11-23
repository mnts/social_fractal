import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/screens/index.dart';
import 'package:social_fractal/widgets/slides.dart';
/*
import 'diagram.dart';
import 'models/diagram.dart';
import 'screens/diagram/ctrl.dart';
*/

final slidesScreen = ScreenFractal(
  name: 'slides',
  title: 'Presentation',
  icon: Icons.slideshow,
  builder: FractalSlides.new,
);

final peopleScreen = ScreenFractal(
  name: 'people',
  icon: Icons.people_outline,
  title: 'People',
  builder: PeopleScreen.new,
);

//final diagramScreen = DiagramScreenFractal();

/*
final rtcScreen = ScreenFractal(
  name: 'rtc',
  icon: Icons.connect_without_contact,
  builder: DataChannelSample.new,
);
*/

final fluffyScreen = ScreenFractal(
  audience: Audience.authenticated,
  name: 'rooms',
  title: 'Communication',
  icon: Icons.chat,
  builder: ChatList.new,
);

final catalogScreen = ScreenFractal(
  name: 'catalog',
  title: 'Catalog',
  icon: Icons.list,
  builder: CatalogScreen.new,
);

final loginScreen = ScreenFractal(
  audience: Audience.notAuthenticated,
  name: 'home/login',
  title: 'Authentication',
  icon: Icons.key,
  builder: ChatList.new,
);

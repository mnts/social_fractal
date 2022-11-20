import 'dart:ui';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';

setup_fluffy() {
  AppConfig.applicationName = 'Social Fractal';
  AppConfig.defaultHomeserver = 'gen.sale';
  AppConfig.appId = 'im.qi.social_fractal';
  AppConfig.applicationWelcomeMessage =
      'Social platform on fractal ecosystem driven by matrix';
  //AppConfig.appOpenUrlScheme = 'im.social_fractal';
  AppConfig.allowOtherHomeservers = false;
  AppConfig.primaryColor = Color.fromARGB(255, 9, 116, 116);
  AppConfig.primaryColorLight = Color.fromARGB(255, 88, 177, 178);
  AppConfig.secondaryColor = Color.fromARGB(255, 188, 108, 65);
}

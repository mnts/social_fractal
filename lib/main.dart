import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:fluffychat/widgets/lock_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:fractal_gold/dex.dart';
import 'package:fractal_gold/schema.dart';
import 'package:fractal_gold/ui.dart';
import 'package:fractals/io.dart';
import 'package:fractals/models/fractal.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'app.dart';
import 'config/fluffychat_config.dart';
import 'fluffy.dart';

void main() async {
  Dex.ipfs;
  await Hive.initFlutter('HiveFStorage');
  await define();

  //Acc.db = sqlite3.open('fractal.db');

  await FractalUI.init();
  FIO.documentsPath = '/Users/mk/Data/Documents';

  await Fractal.init();

  setup_fluffy();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError =
      (FlutterErrorDetails details) => Zone.current.handleUncaughtError(
            details.exception,
            details.stack ?? StackTrace.current,
          );

  runApp(
    PlatformInfos.isMobile
        ? AppLock(
            builder: (args) => FluffyChatApp(),
            lockScreen: const LockScreen(),
            enabled: false,
          )
        : FluffyChatApp(),
  );
}

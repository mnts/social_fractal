import 'dart:async';

import 'package:fluffychat/utils/background_push.dart';
import 'package:fluffychat/widgets/lock_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'config/fluffychat_config.dart';
import 'widgets/fluffy_chat_app.dart';

void main() async {
  // Our background push shared isolate accesses flutter-internal things very early in the startup proccess
  // To make sure that the parts of flutter needed are started up already, we need to ensure that the
  // widget bindings are initialized already.
  setup_fluffy();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError =
      (FlutterErrorDetails details) => Zone.current.handleUncaughtError(
            details.exception,
            details.stack ?? StackTrace.current,
          );

  final clients = await ClientManager.getClients();

  if (PlatformInfos.isMobile) {
    BackgroundPush.clientOnly(clients.first);
  }

  final queryParameters = <String, String>{};
  if (kIsWeb) {
    queryParameters
        .addAll(Uri.parse(html.window.location.href).queryParameters);
  }

  runApp(
    PlatformInfos.isMobile
        ? AppLock(
            builder: (args) => FluffyChatApp(
              clients: clients,
              queryParameters: queryParameters,
            ),
            lockScreen: const LockScreen(),
            enabled: false,
          )
        : FluffyChatApp(
            clients: clients,
            queryParameters: queryParameters,
          ),
  );
}

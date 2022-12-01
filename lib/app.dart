import 'dart:async';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/background_push.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fractal_gold/models/app.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractals/mixins/description.dart';
import 'package:matrix/matrix.dart';

import 'screens.dart';

class SocialAppFractal extends AppFractal with DescriptionFract {
  Map<String, ScreenFractal> screensMap = {};
  SocialAppFractal({
    required super.color,
    required super.icon,
    required super.title,
    super.mainGate,
    super.server,
    super.appId,
    super.actions,
    super.onlyAuthorized,
    super.createProfileFields,
    super.id,
    required super.home,
    super.repoUrl,
    super.screens,
    String description = 'Social app based on matrix',
  }) : clients = [
          //Client(server)..homeserver = Uri.https(server),
        ] {
    for (final screen in screens) {
      screensMap[screen.name.value] = screen;
    }

    descriptionFract(description);
    setup_fluffy();
  }

  setup_fluffy() {
    AppConfig.applicationName = title.value;
    AppConfig.defaultHomeserver = server;
    AppConfig.appId = appId;
    AppConfig.applicationWelcomeMessage = description.value;
    //AppConfig.appOpenUrlScheme = 'im.social_fractal';
    AppConfig.allowOtherHomeservers = false;
    AppConfig.primaryColor = skin.color;
    AppConfig.primaryColorLight = skin.extraColor.withBlue(90);
    AppConfig.secondaryColor = skin.extraColor;
  }

  List<Client> clients;

  String initialUrl = '/';

  Future<bool> initClients() async {
    clients.addAll(
      await ClientManager.getClients(),
    );
    clients.first.homeserver = Uri.https(server, '');
    if (PlatformInfos.isMobile) {
      BackgroundPush.clientOnly(clients.first);
    }
    /*
    initialUrl = clients.any(
      (client) => client.isLogged(),
    )
        ? '/rooms'
        : '/home';
        */
    return true;
  }
}

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/settings_account/settings_account.dart';
import 'package:fluffychat/utils/background_push.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/custom_scroll_behaviour.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fractal_gold/layouts/fractal.dart';
import 'package:matrix/matrix.dart';
import 'package:social_fractal/widgets/avatar.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/config/themes.dart';
import 'app.dart';
import 'config/fluffychat_config.dart';
import 'config/routes.dart';
import 'package:universal_html/html.dart' as html;

import 'widgets/acc.dart';

class FluffyChatApp extends StatefulWidget {
  final Widget? testWidget;
  static GlobalKey<VRouterState> routerKey = GlobalKey<VRouterState>();

  const FluffyChatApp({
    Key? key,
    this.testWidget,
  }) : super(key: key);

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  @override
  FluffyChatAppState createState() => FluffyChatAppState();
}

class FluffyChatAppState extends State<FluffyChatApp> {
  bool? columnMode;
  String? _initialUrl;

  List<Client> clients = [];
  final queryParameters = <String, String>{};

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      queryParameters
          .addAll(Uri.parse(html.window.location.href).queryParameters);
    }
    loadClients();
  }

  loadClients() async {
    ClientManager.getClients().then((value) {
      setState(() {
        clients = value;
        if (PlatformInfos.isMobile) {
          BackgroundPush.clientOnly(clients.first);
        }

        _initialUrl =
            clients.any((client) => client.isLogged()) ? '/rooms' : '/home';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return clients.isEmpty
        ? CupertinoActivityIndicator()
        : DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) => AdaptiveTheme(
              light: FluffyThemes.buildTheme(
                Brightness.light,
                lightColorScheme,
              ),
              dark: FluffyThemes.buildTheme(
                Brightness.dark,
                lightColorScheme,
              ),
              initial: AdaptiveThemeMode.system,
              builder: (theme, darkTheme) => LayoutBuilder(
                builder: (context, constraints) {
                  final isColumnMode =
                      FluffyThemes.isColumnModeByWidth(constraints.maxWidth);
                  if (isColumnMode != columnMode) {
                    Logs().v('Set Column Mode = $isColumnMode');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _initialUrl = FluffyChatApp.routerKey.currentState?.url;
                        columnMode = isColumnMode;
                        FluffyChatApp.routerKey = GlobalKey<VRouterState>();
                      });
                    });
                  }
                  return VRouter(
                    key: FluffyChatApp.routerKey,
                    title: app.title.value,
                    debugShowCheckedModeBanner: false,
                    theme: theme,
                    //scrollBehavior: CustomScrollBehavior(),
                    logs: kReleaseMode ? VLogs.none : VLogs.info,
                    darkTheme: darkTheme,
                    localizationsDelegates: L10n.localizationsDelegates,
                    supportedLocales: L10n.supportedLocales,
                    initialUrl: _initialUrl ?? '/',
                    routes: [
                      ...QIAppRoutes(columnMode ?? false).routes,
                      ...app.screens.map(
                        (screen) => VWidget(
                          path: '/' + screen.name.value,
                          widget: screen.builder(),
                          buildTransition: _transition,
                        ),
                      ),
                      VWidget(
                        path: '/',
                        widget: app.home.builder(),
                        buildTransition: _transition,
                      ),
                    ],
                    builder: (context, child) => Matrix(
                      context: context,
                      router: FluffyChatApp.routerKey,
                      clients: clients,
                      child: FractalLayout(
                        app,
                        isAuthenticated: clients.first.isLogged(),
                        endDrawer: (key) => Drawer(
                          child: SafeArea(
                            child: clients.first.isLogged()
                                ? FractalAcc(scaffoldKey: key)
                                : Container(),
                          ),
                        ),
                        avatar: clients.first.isLogged()
                            ? MatrixFractalAvatar()
                            : Icon(Icons.lock_rounded),
                        child: child,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  ScaleTransition _transition(animation1, _, child) =>
      ScaleTransition(scale: animation1, child: child);
}

import 'dart:async';
import 'dart:ui';
import 'package:fluffychat/utils/background_push.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/lock_screen.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fractal_gold/models/screen.dart';
import 'package:fractal_gold/widgets/listen.dart';
import 'package:social_fractal/areas/login.dart';
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
import 'config/routes.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:collection/collection.dart';

import 'widgets/acc.dart';
import 'widgets/auth.dart';

class SocialFractalApp extends StatefulWidget {
  final Widget? testWidget;
  static GlobalKey<VRouterState> routerKey = GlobalKey<VRouterState>();

  final SocialAppFractal app;

  const SocialFractalApp(
    this.app, {
    Key? key,
    this.testWidget,
  }) : super(key: key);

  /// getInitialLink may rereturn the value multiple times if this view is
  /// opened multiple times for example if the user logs out after they logged
  /// in with qr code or magic link.
  static bool gotInitialLink = false;

  @override
  SocialFractalAppState createState() => SocialFractalAppState();
}

class SocialFractalAppState extends State<SocialFractalApp> {
  bool? columnMode;

  final queryParameters = <String, String>{};

  SocialAppFractal get app => widget.app;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError =
        (FlutterErrorDetails details) => Zone.current.handleUncaughtError(
              details.exception,
              details.stack ?? StackTrace.current,
            );

    app.clients.any((client) => client.isLogged());

    super.initState();

    if (kIsWeb) {
      queryParameters
          .addAll(Uri.parse(html.window.location.href).queryParameters);
    }
  }

  @override
  Widget build(BuildContext context) => PlatformInfos.isMobile
      ? AppLock(
          builder: (args) => buildMain(),
          lockScreen: const LockScreen(),
          enabled: false,
        )
      : buildMain();

  Widget buildMain() => app.clients.isEmpty
      ? CupertinoActivityIndicator()
      : DynamicColorBuilder(
          builder: (lightColorScheme, darkColorScheme) => AdaptiveTheme(
            light: app.skin.theme(false),
            dark: app.skin.theme(true),
            initial: AdaptiveThemeMode.system,
            builder: buildLayout,
          ),
        );

  Widget buildLayout(theme, darkTheme) =>
      LayoutBuilder(builder: (context, constraints) {
        final isColumnMode =
            FluffyThemes.isColumnModeByWidth(constraints.maxWidth);
        if (isColumnMode != columnMode) {
          Logs().v('Set Column Mode = $isColumnMode');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              final url = SocialFractalApp.routerKey.currentState?.url;
              if (url != null) app.initialUrl = url;
              columnMode = isColumnMode;
              SocialFractalApp.routerKey = GlobalKey<VRouterState>();
            });
          });
        }

        final themeCtrl = AdaptiveTheme.of(context);
        return VRouter(
            key: SocialFractalApp.routerKey,
            title: app.title.value,
            debugShowCheckedModeBanner: false,
            theme: theme,
            //scrollBehavior: CustomScrollBehavior(),
            logs: kReleaseMode ? VLogs.none : VLogs.info,
            darkTheme: darkTheme,
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            initialUrl: app.initialUrl,
            routes: [
              ...QIAppRoutes(columnMode ?? false).routes,
              ...app.screens.map(
                (ScreenFractal screen) => VWidget(
                  path: '/' + screen.name.value,
                  widget: FChangeNotifierProvider.value(
                    value: screen,
                    child: screen.builder(),
                  ),
                  buildTransition: _transition,
                ),
              ),
              VWidget(
                path: '/',
                widget: app.home.builder(),
                buildTransition: _transition,
              ),
            ],
            builder: (context, child) {
              final path = context.vRouter.url;
              app.currentScreen = app.screens.firstWhereOrNull(
                (screen) => path.startsWith('/' + screen.name.value),
              );

              return Matrix(
                context: context,
                router: SocialFractalApp.routerKey,
                clients: app.clients,
                child: FractalLayout(
                  app,
                  footer: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          AdaptiveTheme.of(context).toggleThemeMode();
                        },
                        icon: themeCtrl.mode.isSystem
                            ? Icon(Icons.brightness_1)
                            : themeCtrl.mode.isDark
                                ? Icon(Icons.sunny)
                                : Icon(Icons.mode_night),
                      )
                    ],
                  ),
                  isAuthenticated: app.clients.first.isLogged(),
                  endDrawer: (key) => app.clients.first.isLogged()
                      ? FractalAcc(scaffoldKey: key)
                      : FractalAuth(),
                  avatar: app.clients.first.isLogged()
                      ? MatrixFractalAvatar()
                      : Icon(Icons.lock_rounded),
                  child: child,
                ),
              );
            });
      });

  ScaleTransition _transition(animation1, _, child) =>
      ScaleTransition(scale: animation1, child: child);
}

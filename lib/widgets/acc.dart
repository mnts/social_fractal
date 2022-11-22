import 'dart:convert';
import 'dart:typed_data';

import 'package:fluffychat/pages/bootstrap/bootstrap_dialog.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/content_banner.dart';
import 'package:fluffychat/widgets/crypto.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:vrouter/vrouter.dart';

enum AvatarAction { camera, file, remove }

class FractalAcc extends StatefulWidget {
  GlobalKey<ScaffoldState>? scaffoldKey;
  FractalAcc({this.scaffoldKey, super.key});

  @override
  State<FractalAcc> createState() => _FractalAccState();
}

class _FractalAccState extends State<FractalAcc> {
  Future<dynamic>? profileFuture;
  Profile? profile;
  bool profileUpdated = false;

  void updateProfile() => setState(() {
        profileUpdated = true;
        profile = profileFuture = null;
      });

  void setAvatarAction() async {
    final actions = [
      if (PlatformInfos.isMobile)
        SheetAction(
          key: AvatarAction.camera,
          label: L10n.of(context)!.openCamera,
          isDefaultAction: true,
          icon: Icons.camera_alt_outlined,
        ),
      SheetAction(
        key: AvatarAction.file,
        label: L10n.of(context)!.openGallery,
        icon: Icons.photo_outlined,
      ),
      if (profile?.avatarUrl != null)
        SheetAction(
          key: AvatarAction.remove,
          label: L10n.of(context)!.removeYourAvatar,
          isDestructiveAction: true,
          icon: Icons.delete_outlined,
        ),
    ];
    final action = actions.length == 1
        ? actions.single.key
        : await showModalActionSheet<AvatarAction>(
            context: context,
            title: L10n.of(context)!.changeYourAvatar,
            actions: actions,
          );
    if (action == null) return;
    final matrix = Matrix.of(context);
    if (action == AvatarAction.remove) {
      final success = await showFutureLoadingDialog(
        context: context,
        future: () => matrix.client.setAvatar(null),
      );
      if (success.error == null) {
        updateProfile();
      }
      return;
    }
    MatrixFile file;
    if (PlatformInfos.isMobile) {
      final result = await ImagePicker().pickImage(
        source: action == AvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 50,
      );
      if (result == null) return;
      file = MatrixFile(
        bytes: await result.readAsBytes(),
        name: result.path,
      );
    } else {
      final result =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (result.fileName == null) return;
      file = MatrixFile(
        bytes: result.toUint8List(),
        name: result.fileName!,
      );
    }
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.setAvatar(file),
    );
    if (success.error == null) {
      updateProfile();
    }
  }

  close() {
    widget.scaffoldKey?.currentState?.closeEndDrawer();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkBootstrap());

    super.initState();
  }

  void checkBootstrap() async {
    final client = Matrix.of(context).client;
    if (!client.encryptionEnabled) return;
    await client.accountDataLoading;
    await client.userDeviceKeysLoading;
    if (client.prevBatch == null) {
      await client.onSync.stream.first;
    }
    final crossSigning =
        await client.encryption?.crossSigning.isCached() ?? false;
    final needsBootstrap =
        await client.encryption?.keyManager.isCached() == false ||
            client.encryption?.crossSigning.enabled == false ||
            crossSigning == false;
    final isUnknownSession = client.isUnknownSession;
    setState(() {
      showChatBackupBanner = needsBootstrap || isUnknownSession;
    });
  }

  bool? crossSigningCached;
  bool showChatBackupBanner = false;

  void firstRunBootstrapAction() async {
    close();
    await BootstrapDialog(
      client: Matrix.of(context).client,
    ).show(context);
    checkBootstrap();
  }

  void setDisplaynameAction() async {
    close();
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.editDisplayname,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          initialText: profile?.displayName ??
              Matrix.of(context).client.userID!.localpart,
        )
      ],
    );
    if (input == null) return;
    final matrix = Matrix.of(context);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () =>
          matrix.client.setDisplayName(matrix.client.userID!, input.single),
    );
    if (success.error == null) {
      updateProfile();
    }
  }

  void logoutAction() async {
    close();
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.areYouSureYouWantToLogout,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final matrix = Matrix.of(context);
    await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.logout(),
    );
  }

  void deleteAccountAction() async {
    close();
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.warning,
          message: L10n.of(context)!.deactivateAccountWarning,
          okLabel: L10n.of(context)!.ok,
          cancelLabel: L10n.of(context)!.cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final supposedMxid = Matrix.of(context).client.userID!;
    final mxids = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.confirmMatrixId,
      textFields: [
        DialogTextField(
          validator: (text) => text == supposedMxid
              ? null
              : L10n.of(context)!.supposedMxid(supposedMxid),
        ),
      ],
      okLabel: L10n.of(context)!.delete,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (mxids == null || mxids.length != 1 || mxids.single != supposedMxid) {
      return;
    }
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.pleaseEnterYourPassword,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        const DialogTextField(
          obscureText: true,
          hintText: '******',
          minLines: 1,
          maxLines: 1,
        )
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.deactivateAccount(
            auth: AuthenticationPassword(
              password: input.single,
              identifier: AuthenticationUserIdentifier(
                  user: Matrix.of(context).client.userID!),
            ),
          ),
    );
  }

  Future<void> dehydrateAction() => dehydrateDevice(context);

  static Future<void> dehydrateDevice(BuildContext context) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      isDestructiveAction: true,
      title: L10n.of(context)!.dehydrate,
      message: L10n.of(context)!.dehydrateWarning,
    );
    if (response != OkCancelResult.ok) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          final export = await Matrix.of(context).client.exportDump();
          final filePickerCross = FilePickerCross(
              Uint8List.fromList(const Utf8Codec().encode(export!)),
              path:
                  '/fluffychat-export-${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}.fluffybackup',
              fileExtension: 'fluffybackup');
          await filePickerCross.exportToStorage(
            subject: L10n.of(context)!.dehydrateShare,
          );
        } catch (e, s) {
          Logs().e('Export error', e, s);
        }
      },
    );
  }

  void addAccountAction() => VRouter.of(context).to('add');

  @override
  Widget build(BuildContext context) {
    final lang = L10n.of(context)!;
    final client = Matrix.of(context).client;

    profileFuture ??= client
        .getProfileFromUserId(
      client.userID!,
      cache: !profileUpdated,
      getFromRooms: !profileUpdated,
    )
        .then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            title: Text(
              profile?.displayName ??
                  Matrix.of(context).client.userID!.localpart!,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ContentBanner(
                mxContent: profile?.avatarUrl,
                //onEdit: setAvatarAction,
                //defaultIcon: Icons.account_circle_outlined,
              ),
            ),
          ),
        ],
        body: ListTileTheme(
          iconColor: Theme.of(context).colorScheme.onBackground,
          child: ListView(children: <Widget>[
            ListTile(
              trailing: Icon(Icons.person),
              title: Text(lang.yourUserId),
              subtitle: Text(client.userID!),
              //trailing: const Icon(Icons.copy_outlined),
              onTap: () => FluffyShare.share(
                client.userID!,
                context,
              ),
            ),
            FractalCrypto(name: client.userID!),
            const Divider(height: 1),
            ElevatedButton.icon(
              onPressed: () async {
                client.logout();
              },
              icon: Icon(Icons.exit_to_app_outlined),
              label: Text(lang.logout),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(L10n.of(context)!.settings),
              onTap: () => go('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.format_paint_outlined),
              title: Text(L10n.of(context)!.changeTheme),
              onTap: () => go('/settings/style'),
            ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context)!.notifications),
              onTap: () => go('/settings/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(L10n.of(context)!.devices),
              onTap: () => go('/settings/devices'),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_outlined),
              title: Text(L10n.of(context)!.chat),
              onTap: () => go('/settings/chat'),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(L10n.of(context)!.account),
              onTap: () => go('/settings/account'),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(L10n.of(context)!.security),
              onTap: () => go('/settings/security'),
            ),
          ]),
        ),
      ),
    );
  }

  go(String path) {
    VRouter.of(context).to(path);
    close();
  }
}

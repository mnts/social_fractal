import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/m2_popup_menu_button.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MatrixFractalAvatar extends StatelessWidget {
  const MatrixFractalAvatar({super.key});
  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    return FutureBuilder<Profile>(
      future: matrix.client.fetchOwnProfile(),
      builder: (context, snapshot) => Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(99),
        child: Avatar(
          mxContent: snapshot.data?.avatarUrl,
          name: snapshot.data?.displayName ?? matrix.client.userID!.localpart,
          size: 52,
          fontSize: 16,
        ),
      ),
    );
  }
}

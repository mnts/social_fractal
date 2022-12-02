import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MatrixName extends StatefulWidget {
  TextStyle? style;
  MatrixName({
    super.key,
    this.style,
  });

  @override
  State<MatrixName> createState() => _MatrixNameState();
}

class _MatrixNameState extends State<MatrixName> {
  Future<dynamic>? profileFuture;
  Profile? profile;
  bool profileUpdated = false;

  void updateProfile() => setState(() {
        profileUpdated = true;
        profile = profileFuture = null;
      });

  @override
  Widget build(BuildContext context) {
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

    return Text(
      profile?.displayName ?? Matrix.of(context).client.userID!.localpart!,
      style: widget.style,
    );
  }
}

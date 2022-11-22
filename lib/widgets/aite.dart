import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/crypto.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class FractalSite extends StatefulWidget {
  const FractalSite({super.key});

  @override
  State<FractalSite> createState() => _FractalSiteState();
}

class _FractalSiteState extends State<FractalSite> {
  @override
  Widget build(BuildContext context) {
    final lang = L10n.of(context)!;
    final client = Matrix.of(context).client;

    return Column(children: []);
  }
}

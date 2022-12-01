import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

import '../areas/login.dart';

class FractalAuth extends StatefulWidget {
  const FractalAuth({super.key});

  @override
  State<FractalAuth> createState() => _FractalAuthState();
}

class _FractalAuthState extends State<FractalAuth> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: TabBar(
              tabs: [
                Tab(
                  text: Matrix.of(context)
                      .getLoginClient()
                      .homeserver
                      .toString()
                      .replaceFirst('https://', ''),
                ),
                /*
                                    Tab(
                                      icon: Icon(Icons.connect_without_contact),
                                    ),
                                    */
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            QILogin(),
            //Icon(Icons.people),
          ],
        ),
      ),
    );
  }
}

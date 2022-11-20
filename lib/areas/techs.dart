import 'package:flutter/material.dart';

import '/components/tech.dart';
import '/data/techs.dart';
import 'package:flutter/widgets.dart';

class TechsArea extends StatefulWidget {
  const TechsArea({Key? key}) : super(key: key);

  @override
  _TechsAreaState createState() => _TechsAreaState();
}

class _TechsAreaState extends State<TechsArea> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //Container(height: 20, child: Text('hello')),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Techs.map((a) => TechW(item: a)).toList(),
          ),
        ),
      ),
    ]);
  }
}

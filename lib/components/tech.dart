import 'package:flutter/material.dart';
import 'package:social_fractal/utils/strip_margin.dart';
import "package:velocity_x/velocity_x.dart";

import '../models/tech.dart';

class TechW extends StatelessWidget {
  Tech item;
  TechW({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480,
      height: 200,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xCC363333),
        border: Border.all(
          color: Color(0x98070707),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(5),
      child: [
        Container(
          child: item.logo,
          width: 128,
          height: 128,
        ).p12(),
        [
          Text(
            item.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          VxRating(
            onRatingUpdate: (value) {},
            count: 5,
            selectionColor: Colors.teal,
            size: 16,
          ),
          Container(
            height: 116,
            child: Text(
              stripMargin(item.desc),
              softWrap: true,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ].vStack(crossAlignment: CrossAxisAlignment.start).expand(),
      ].hStack(),
    );
  }
}

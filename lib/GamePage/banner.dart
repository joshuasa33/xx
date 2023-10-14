import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Helper/globals.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            maxWidth * 0.065, maxHeight * 0.8, maxWidth * 0.065, 0),
        child: Container(
          decoration: BoxDecoration(
            color: objglobals.mainColor,
            border: Border.all(
              width: maxHeight * 0.005, // adjust border thickness as desired
              color: Colors.black, // choose border color
              style: BorderStyle.solid, // choose border style
            ),
          ),
          height: maxHeight * 0.08,
          width: double.maxFinite,
        ),
      ),
    );
  }
}

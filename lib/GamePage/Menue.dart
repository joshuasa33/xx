import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:testre/CharPage/CharUI.dart';
import 'package:testre/GamePage/GamePage.dart';

import '../Helper/globals.dart';

class BottomMenue extends StatefulWidget {
  final int getindex;
  const BottomMenue({super.key, required this.getindex});

  @override
  State<BottomMenue> createState() => _BottomMenueState();
}

class _BottomMenueState extends State<BottomMenue> {
  @override
  void initState() {
    super.initState();
    indexSwap(widget.getindex);
  }

  void indexSwap(int index) {
    Globals objglobals = Globals();

    colors[index] = objglobals.secondColor;
  }

  void resolvePage(int index) {
    setState(() {
      Globals objglobals = Globals();
      colors[0] = objglobals.mainColor;
      colors[1] = objglobals.mainColor;
      colors[2] = objglobals.mainColor;
      colors[3] = objglobals.mainColor;

      colors[index] = objglobals.secondColor;
      context.read<GamePageIndex>().changeIndex(index);
    });
  }

  List<Color> colors = [
    Color.fromRGBO(242, 233, 0, 1),
    Color.fromRGBO(242, 233, 0, 1),
    Color.fromRGBO(242, 233, 0, 1),
    Color.fromRGBO(242, 233, 0, 1)
  ];
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();

    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: maxHeight * 0.89),
        child: Container(
          width: maxWidth,
          height: maxHeight * 0.11,
          decoration: BoxDecoration(
            color: objglobals.mainColor,
            border: Border(
              top: BorderSide(
                width: maxHeight * 0.005, // adjust border thickness as desired
                color: Colors.black, // choose border color
                style: BorderStyle.solid, // choose border style
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  resolvePage(0);
                  context.read<PageViewIndex>().changeIndex(0);
                },
                child: Container(
                  color: colors[0],
                  width: maxWidth * 0.25,
                  height: maxHeight * 0.11,
                  child: Padding(
                    padding: EdgeInsets.all(maxWidth * 0.04),
                    child: Image.asset('lib/Icons/shopping-cart.png'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  resolvePage(1);
                  // Access the PageController and change its value
                  context.read<PageViewIndex>().changeIndex(1);
                },
                child: Container(
                  color: colors[1],
                  width: maxWidth * 0.25,
                  height: maxHeight * 0.11,
                  child: Padding(
                    padding: EdgeInsets.all(maxWidth * 0.04),
                    child: Image.asset('lib/Icons/man.png'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  resolvePage(2);
                  context.read<PageViewIndex>().changeIndex(2);
                },
                child: Container(
                  color: colors[2],
                  width: maxWidth * 0.25,
                  height: maxHeight * 0.11,
                  child: Padding(
                    padding: EdgeInsets.all(maxWidth * 0.04),
                    child: Image.asset('lib/Icons/water-gun.png'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  resolvePage(3);

                  context.read<PageViewIndex>().changeIndex(3);
                },
                child: Container(
                  color: colors[3],
                  width: maxWidth * 0.25,
                  height: maxHeight * 0.11,
                  child: Padding(
                    padding: EdgeInsets.all(maxWidth * 0.04),
                    child: Image.asset('lib/Icons/artificial-intelligence.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorIndex extends ChangeNotifier {
  int getcolorindex = 2;

  void changeIndex(getindex) {
    getcolorindex = getindex;
    notifyListeners();
  }
}

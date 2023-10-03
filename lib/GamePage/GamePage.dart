import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:testre/CharPage/CharUI.dart';
import 'package:testre/GamePage/Menue.dart';
import 'package:testre/SettingsPage/SettingUI.dart';

import '../Helper/globals.dart';
import '../Helper/httpMetaData.dart';
import '../ShopPage/ShopUI.dart';
import 'StartSocket.dart';
import 'banner.dart';
import 'fightPage.dart';
import 'initfragen.dart';

//getDataStartGame(context);
int passindex = 2;
// connectToWebSocket("500", "100");

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    fetchMetadata(context);
    getCharData(context);
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: objglobals.mainColor,
        child: Stack(children: [
          PageView(
            onPageChanged: (value) {
              if (context.read<SearchSocket>().state == true) {
                connectToWebSocket("", "", context, "", "", "", close: true);
              }
              context.read<GamePageIndex>().changeIndex(index);
              setState(() {
                passindex = value;
              });
              print("changed$value");
            },
            controller: context.read<PageViewIndex>()._pageController,
            children: const [
              ShopPage(),
              CharPage(),
              FightPage(),
              SettingPage(),
            ],
          ),

          //Bottom Menue
          BottomMenue(
            key: UniqueKey(),
            getindex: passindex,
          ),
          Visibility(
              visible: context.watch<WhileShopping>().state,
              child: const WaitingShopResponse()),

          Visibility(
              visible: context.watch<showError>().showText,
              child: const erroTextOverlay()),
        ]),
      ),
    );
  }
}

class GamePageIndex extends ChangeNotifier {
  int index = 3;

  void changeIndex(getindex) {
    index = getindex;
    notifyListeners();
  }
}

class PageViewIndex extends ChangeNotifier {
  final PageController _pageController = PageController(initialPage: 2);

  void changeIndex(getindex) {
    _pageController.animateToPage(getindex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInToLinear);
    notifyListeners();
  }
}

class WhileShopping extends ChangeNotifier {
  bool state = false;

  void changeIndex(bool getstate) {
    state = getstate;
    notifyListeners();
  }
}

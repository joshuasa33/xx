import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testre/CharPage/CharUI.dart';
import 'package:testre/GamePage/Menue.dart';
import 'package:testre/SettingsPage/SettingUI.dart';

import '../Helper/globals.dart';
import '../Helper/httpMetaData.dart';
import '../ShopPage/ShopUI.dart';
import 'StartSocket.dart';
import 'fightPage.dart';

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
                if (mounted) {
                  passindex = value;
                }
              });
            },
            controller: context.read<PageViewIndex>()._pageController,
            children: [
              const ShopPage(),
              const CharPage(),
              FightPage(
                key: UniqueKey(),
              ),
              const SettingPage(),
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:testre/INGAME/ingame.dart';
import 'package:testre/INGAME/reskin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Ads/admob_meteData.dart';
import 'GamePage/GamePage.dart';
import 'GamePage/Menue.dart';
import 'GamePage/fightPage.dart';
import 'GamePage/initfragen.dart';
import 'LoginPage/UIloginPage.dart';
import 'ShopPage/ShopUI.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//IAP

final _configurationIOS =
    PurchasesConfiguration("appl_fxrRuarcPliSqvatZqUnWQZFdOL");
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  if (Platform.isIOS) {
    await Purchases.configure(_configurationIOS); //IAP
  }
  String getplayerguid = "";
  bool getfirstime = true;
  const constguid = "playerguid";
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //

  if (prefs.containsKey(constguid)) {
    getplayerguid = prefs.getString(constguid)!;
    getfirstime = false;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchSocket()),
        ChangeNotifierProvider(create: (context) => PlayerElo()),
        ChangeNotifierProvider(create: (context) => PlayerName()),
        ChangeNotifierProvider(create: (context) => PlayerMoney()),
        ChangeNotifierProvider(create: (context) => GameFinish()),
        ChangeNotifierProvider(create: (context) => GamePageIndex()),
        ChangeNotifierProvider(create: (context) => ModelPath()),
        ChangeNotifierProvider(create: (context) => BGPath()),
        ChangeNotifierProvider(create: (context) => Buyable()),
        ChangeNotifierProvider(create: (context) => ItemsChar()),
        ChangeNotifierProvider(create: (context) => ItemsBG()),
        ChangeNotifierProvider(create: (context) => AdStateProvider()),
        ChangeNotifierProvider(create: (context) => PageViewIndex()),
        ChangeNotifierProvider(create: (context) => ColorIndex()),
        ChangeNotifierProvider(create: (context) => WhileShopping()),
        ChangeNotifierProvider(create: (context) => PopupError()),
        ChangeNotifierProvider(create: (context) => showError()),
        ChangeNotifierProvider(create: (context) => ModelPathEnemy()),
        ChangeNotifierProvider(create: (context) => BGPathEnemy()),
        ChangeNotifierProvider(create: (context) => BGPathEnemy()),
        ChangeNotifierProvider(create: (context) => enemyName()),
      ],
      child: MyApp(
        playerguid: getplayerguid,
        firsttime: getfirstime,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String playerguid;
  final bool firsttime;

  const MyApp({Key? key, required this.playerguid, required this.firsttime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigate to the appropriate page based on the value of `firsttime`
    Widget nextPage;
    if (firsttime) {
      nextPage = const Login();
    } else {
      //Test purpose
      CFragen obj = CFragen(
          Frage: "Wie heißt der bürgermeister von bikini bottom?",
          Antwort1: "Antwort1",
          Antwort2: "Antwort2",
          Antwort3: "Antwort3",
          Antwort4: "Antwort4",
          RichtigeAntwort: "Antwort3",
          Laendercode: "Laendercode",
          Kategorie: "Kategorie");
      List<CFragen> listobj = [];
      listobj.add(obj);
      listobj.add(obj);
      listobj.add(obj);
      listobj.add(obj);

      //End
      nextPage = GamePage();
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: nextPage,
      routes: {
        '/inGame': (context) => const InGame(),
        '/gamePage': (context) => const GamePage(),
      },
    );
  }
}

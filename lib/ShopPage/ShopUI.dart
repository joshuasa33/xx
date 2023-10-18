// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:testre/Ads/admob_meteData.dart';
import 'package:testre/ShopPage/pushCoins.dart';
import 'package:testre/ShopPage/shopFile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Ads/rewardedads.dart';
import '../CharPage/fileChar.dart';
import '../GamePage/GamePage.dart';
import '../GamePage/fightPage.dart';
import '../Helper/globals.dart';
import '../Helper/httpMetaData.dart';
import 'buyHTTP.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  void changeShopState(bool state) {
    context.read<WhileShopping>().changeIndex(state);
  }

  void getShopData(BuildContext context) async {
    await getItems(context);
  }

  @override
  void initState() {
    getShopData(context);
    createRewardedAd(
        context, AdHelper.getRewardedAdID(WhichRewardedAD.rewardedCoins));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      color: objglobals.mainColor,
      child: Column(children: [
        //Top Header

        Padding(
          padding: EdgeInsets.fromLTRB(
              maxWidth * 0.0, maxHeight * 0.078, maxWidth * 0.00, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: maxHeight * 0.003,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: maxHeight * 0.003,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            height: maxHeight * 0.05,
            width: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  color: objglobals.secondColor,
                  height: maxHeight,
                  width: maxWidth,
                  child: AutoSizeText(
                    "Shop",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: maxWidth * 0.65),
                  child: Container(
                    height: maxHeight,
                    width: maxWidth * 0.08,
                    child: Image.asset("lib/Icons/bitcoin.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      maxWidth * 0.73, maxHeight * 0.004, 0, 0),
                  child: Container(
                    height: maxHeight,
                    width: maxWidth * 0.3,
                    child: AutoSizeText(
                      context.watch<PlayerMoney>().playerMoney,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.getFont(
                        'Orbitron', // Replace with your desired Google Font
                        textStyle: const TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //ad
        //Ad
        Visibility(
          visible: context.watch<AdStateProvider>().isloaded,
          child: GestureDetector(
            onTap: () {
              showRewardedAd(context,
                  AdHelper.getRewardedAdID(WhichRewardedAD.rewardedCoins));
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(maxWidth * 0.7, 0, 0, 0),
              child: Container(
                color: objglobals.fourthColor,
                width: maxWidth * 0.3,
                height: maxHeight * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: maxHeight * 0.04,
                      width: maxWidth * 0.11,
                      child: Image.asset("lib/Icons/film.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: maxWidth * 0.02),
                      child: AutoSizeText(
                        "+20",
                        style: GoogleFonts.getFont(
                          'Orbitron', // Replace with your desired Google Font
                          textStyle: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        //Chars
        Container(
          width: maxWidth,
          height: maxHeight * 0.77,
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              //Buy Coins
              Padding(
                padding: EdgeInsets.fromLTRB(
                    maxWidth * 0.045, 0, maxWidth * 0.045, 0),
                child: Container(
                  width: maxWidth,
                  height: maxHeight * 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Get the product to purchase.
                            StoreProduct product200C = const StoreProduct(
                                "QuizPvP_200C",
                                "description",
                                "title",
                                1.99,
                                "priceString",
                                "currencyCode");
                            try {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult ==
                                  ConnectivityResult.none) {
                                return;
                              } else {}
                              changeShopState(true);
                              await Purchases.purchaseStoreProduct(product200C);
                              //Push coins
                              String playerguid = "";
                              const constguid = "playerguid";
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.containsKey(constguid)) {
                                playerguid = prefs.getString(constguid)!;
                              }
                              int getcoins = await saveCoins(200);
                              await pushCoins(playerguid, getcoins);
                              await fetchMetadata(context);
                              debugPrint("Worked");
                            } catch (E) {
                              debugPrint("PurchaseError200$E");
                            } finally {
                              changeShopState(false);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: maxWidth * 0.0035),
                            ),
                            width: maxWidth * 0.3,
                            height: maxHeight * 0.25,
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.01),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: maxHeight * 0.0035,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  width: maxWidth,
                                  height: maxHeight * 0.04,
                                  child: AutoSizeText(
                                    "200",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Orbitron', // Replace with your desired Google Font
                                      textStyle: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.00),
                                child: Container(
                                  width: maxWidth * 0.22,
                                  height: maxHeight * 0.13,
                                  child: Image.asset("lib/Icons/bitcoin.png"),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: maxHeight * 0.0035,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                width: maxWidth,
                                height: maxHeight * 0.04,
                                child: AutoSizeText(
                                  "1.99€",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Orbitron', // Replace with your desired Google Font
                                    textStyle: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Get the product to purchase.
                            StoreProduct product600C = const StoreProduct(
                                "QuizPvP_600C",
                                "description",
                                "title",
                                4.99,
                                "priceString",
                                "currencyCode");
                            try {
                              changeShopState(true);

                              await Purchases.purchaseStoreProduct(product600C);
                              //Push coins
                              String playerguid = "";
                              const constguid = "playerguid";
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.containsKey(constguid)) {
                                playerguid = prefs.getString(constguid)!;
                              }
                              int getcoins = await saveCoins(600);
                              await pushCoins(playerguid, getcoins);
                              await fetchMetadata(context);
                              debugPrint("Worked");
                            } catch (E) {
                              debugPrint("PurchaseError200$E");
                            } finally {
                              changeShopState(false);
                            }
                            debugPrint("Worked");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: maxWidth * 0.0035),
                            ),
                            width: maxWidth * 0.3,
                            height: maxHeight * 0.25,
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.01),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: maxHeight * 0.0035,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  width: maxWidth,
                                  height: maxHeight * 0.04,
                                  child: AutoSizeText(
                                    "600",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Orbitron', // Replace with your desired Google Font
                                      textStyle: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.00),
                                child: Container(
                                  width: maxWidth * 0.22,
                                  height: maxHeight * 0.13,
                                  child: Image.asset("lib/Icons/bitcoin.png"),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: maxHeight * 0.0035,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                width: maxWidth,
                                height: maxHeight * 0.04,
                                child: AutoSizeText(
                                  "4.99€",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Orbitron', // Replace with your desired Google Font
                                    textStyle: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Get the product to purchase.
                            StoreProduct product1300c = const StoreProduct(
                                "QuizPvP_1300C",
                                "description",
                                "title",
                                9.99,
                                "priceString",
                                "currencyCode");
                            try {
                              changeShopState(true);
                              await Purchases.purchaseStoreProduct(
                                  product1300c);
                              //Push coins
                              String playerguid = "";
                              const constguid = "playerguid";
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (prefs.containsKey(constguid)) {
                                playerguid = prefs.getString(constguid)!;
                              }
                              int getcoins = await saveCoins(1300);
                              await pushCoins(playerguid, getcoins);
                              await fetchMetadata(context);
                              debugPrint("Worked");
                            } catch (E) {
                              debugPrint("PurchaseError200$E");
                            } finally {
                              changeShopState(false);
                            }
                            debugPrint("Worked");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: maxWidth * 0.0035),
                            ),
                            width: maxWidth * 0.3,
                            height: maxHeight * 0.25,
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.01),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: maxHeight * 0.0035,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  width: maxWidth,
                                  height: maxHeight * 0.04,
                                  child: AutoSizeText(
                                    "1300",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont(
                                      'Orbitron', // Replace with your desired Google Font
                                      textStyle: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: maxHeight * 0.00),
                                child: Container(
                                  width: maxWidth * 0.22,
                                  height: maxHeight * 0.13,
                                  child: Image.asset("lib/Icons/bitcoin.png"),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: maxHeight * 0.0035,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                width: maxWidth,
                                height: maxHeight * 0.04,
                                child: AutoSizeText(
                                  "9.99€",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Orbitron', // Replace with your desired Google Font
                                    textStyle: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //CHARS
              Visibility(
                visible:
                    context.watch<ItemsChar>().shopItems.assetLinkSS.isNotEmpty,
                child: Container(
                  width: maxWidth,
                  height: maxHeight * 0.41,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: maxWidth * 0.02,
                      ),
                      for (int i = 0;
                          i <
                              context
                                  .watch<ItemsChar>()
                                  .shopItems
                                  .assetLinkSS
                                  .length;
                          i++)
                        (Item(
                          items: context.watch<ItemsChar>().shopItems,
                          index: i,
                        )),
                      SizedBox(
                        width: maxWidth * 0.04,
                      ),
                    ],
                  ),
                ),
              ),
              //BGS
              Visibility(
                visible:
                    context.watch<ItemsBG>().shopItems.assetLinkSS.isNotEmpty,
                child: Container(
                  width: maxWidth,
                  height: maxHeight * 0.41,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: maxWidth * 0.02,
                      ),
                      for (int i = 0;
                          i <
                              context
                                  .watch<ItemsBG>()
                                  .shopItems
                                  .assetLinkSS
                                  .length;
                          i++)
                        (Item(
                          items: context.watch<ItemsBG>().shopItems,
                          index: i,
                        )),
                      SizedBox(
                        width: maxWidth * 0.04,
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: context.watch<AdStateProvider>().isloaded,
                child: Container(
                  color: objglobals.mainColor,
                  width: maxWidth * 0.3,
                  height: maxHeight * 0.04,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class Item extends StatefulWidget {
  final ShopItems items;
  final int index;
  const Item({super.key, required this.items, required this.index});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    bool canBuy = context.watch<Buyable>().canbuy;
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    int price = 500;
    if (widget.items.assetCategory[widget.index] == "Char") {
      price = 500;
    }
    if (widget.items.assetCategory[widget.index] == "BG") {
      price = 200;
    }
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.fromLTRB(maxWidth * 0.02, maxHeight * 0.01, 0, 0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: maxHeight * 0.007,
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                  top: BorderSide(
                    width: maxHeight * 0.007,
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                  left: BorderSide(
                    width: maxHeight * 0.007,
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                  right: BorderSide(
                    width: maxHeight * 0.007,
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              width: maxWidth * 0.6,
              height: maxHeight * 0.27,
              child: Image(
                image: AssetImage(widget.items.assetLinkSS[widget.index]),
                fit: BoxFit.fill,
              ),
            ),
            GestureDetector(
              onTap: () {
                popup(
                  context,
                  maxHeight,
                  maxWidth,
                  widget.items.assetName[widget.index],
                  widget.items.assetCategory[widget.index],
                  widget.items.assetLink[widget.index],
                  widget.items.assetLinkSS[widget.index],
                );
                context.read<PopupError>().swapState(false);
              },
              child: Container(
                width: maxWidth * 0.6,
                height: maxHeight * 0.05,
                color: objglobals.fourthLight,
                child: Padding(
                  padding: EdgeInsets.only(top: maxHeight * 0.005),
                  child: AutoSizeText(
                    "Vorschau",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: maxWidth * 0.6,
              height: maxHeight * 0.06,
              child: Padding(
                padding: EdgeInsets.only(top: maxHeight * 0.00),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(maxHeight * 0.00)),
                      backgroundColor: objglobals.fourthColor),
                  onPressed: canBuy
                      ? () async {
                          try {
                            setState(() {
                              if (mounted) {
                                context.read<Buyable>().updateBuyable(false);
                              }
                            });
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? playerguid = prefs.getString("playerguid");
                            int httpcode = await callBuyItem(
                                widget.items.assetName[widget.index],
                                playerguid!);
                            debugPrint(httpcode.toString());
                            if (httpcode == 200) {
                              debugPrint("worked");
                              addItem(
                                  widget.items.assetName[widget.index],
                                  widget.items.assetCategory[widget.index],
                                  widget.items.assetLink[widget.index],
                                  widget.items.assetLinkSS[widget.index]);
                              await fetchMetadata(context);
                              await getItems(context);
                            }
                            if (httpcode == 502) {
                              debugPrint("not enough coins re");
                              setState(() {
                                if (mounted) {
                                  context.read<showError>().swapState(true);
                                }
                              });
                              await fetchMetadata(context);
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                context.read<Buyable>().updateBuyable(true);
                              });
                            }
                          }
                        }
                      : null,
                  child: AutoSizeText(
                    price.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void popup(BuildContext context, double maxHeight, double maxWidth,
    String assetName, String category, String assetLink, String assetLinkSS) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      int price = 0;
      bool canBuy = context.watch<Buyable>().canbuy;
      if (category == "BG") {
        price = 200;
      } else {
        price = 500;
      }

      bool char = false;
      bool bg = false;
      bool border = false;
      if (category == "Char") {
        char = true;
      }
      if (category == "BG") {
        bg = true;
      }
      Globals objglobals = Globals();
      return Container(
        height: maxHeight,
        width: maxWidth,
        color: const Color.fromARGB(216, 0, 0, 0),
        child: Column(
          children: [
            char
                ? Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.03),
                    child: Container(
                      width: maxWidth,
                      height: maxHeight * 0.35,
                      child: SizedBox(
                        //color: Colors.amber,
                        width: maxWidth,
                        height: maxHeight * 0.43,
                        child: ModelViewer(
                          src: assetLink,
                          alt: 'My 3D Model',
                          autoRotate: true, // Enable auto-rotation
                          rotationPerSecond: "90deg",
                          autoRotateDelay: 0,
                          cameraControls: false, // Enable camera controls
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            //BG
            bg
                ? Padding(
                    padding: EdgeInsets.only(top: maxHeight * 0.03),
                    child: Container(
                      color: Colors.green,
                      width: maxWidth * 0.6,
                      height: maxHeight * 0.35,
                      child: Container(
                        //color: Colors.amber,
                        height: maxHeight * 0.43,
                        child: Image.asset(
                          assetLink,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),

            //Buy Button
            Padding(
              padding: EdgeInsets.fromLTRB(0, maxHeight * 0.02, 0, 0),
              child: Container(
                width: maxWidth * 0.7,
                height: maxHeight * 0.07,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: objglobals.fourthColor,
                  ),
                  onPressed: canBuy
                      ? () async {
                          try {
                            context.read<Buyable>().updateBuyable(false);

                            canBuy = false;
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? playerguid = prefs.getString("playerguid");
                            int httpcode =
                                await callBuyItem(assetName, playerguid!);
                            debugPrint(httpcode.toString());
                            if (httpcode == 200) {
                              debugPrint("worked");
                              addItem(
                                  assetName, category, assetLink, assetLinkSS);
                              await fetchMetadata(context);
                              await getItems(context);
                              Navigator.pop(context);
                            }
                            if (httpcode == 502) {
                              context.read<PopupError>().swapState(true);
                              debugPrint("not enough coins re");
                              const WaitingShopResponse();
                              await fetchMetadata(context);
                            }
                          } finally {
                            context.read<Buyable>().updateBuyable(true);
                          }
                        }
                      : null,
                  child: AutoSizeText(
                    price.toString(),
                    style: GoogleFonts.getFont(
                      'Orbitron', // Replace with your desired Google Font
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: context.watch<PopupError>().showText,
              child: Container(
                width: maxWidth * 0.7,
                height: maxHeight * 0.02,
                child: AutoSizeText(
                  "Nicht genügend Coins",
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

class WaitingShopResponse extends StatefulWidget {
  const WaitingShopResponse({super.key});

  @override
  State<WaitingShopResponse> createState() => _WaitingShopResponseState();
}

class _WaitingShopResponseState extends State<WaitingShopResponse> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      width: maxWidth,
      height: maxHeight,
      color: const Color.fromARGB(169, 255, 255, 255),
      child: Column(
        children: [
          Container(
              width: maxHeight * 0.3,
              height: maxHeight * 0.9,
              child: Lottie.asset('lib/images/animation_lmr4ottp.json')),
        ],
      ),
    );
  }
}

class erroTextOverlay extends StatefulWidget {
  const erroTextOverlay({super.key});

  @override
  State<erroTextOverlay> createState() => _erroTextOverlayState();
}

class _erroTextOverlayState extends State<erroTextOverlay> {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => context.read<showError>().swapState(false),
      child: Container(
        width: maxWidth,
        height: maxHeight,
        color: const Color.fromARGB(169, 255, 255, 255),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: maxHeight * 0.35),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 0, 205),
                  border: Border.all(width: maxHeight * 0.0065),
                ),
                width: maxWidth * 0.7,
                height: maxHeight * 0.1,
                child: Center(
                    child: AutoSizeText(
                  "Zu wenige Coins",
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopupError extends ChangeNotifier {
  bool showText = false;

  void swapState(bool state) {
    showText = state;
    notifyListeners();
  }
}

class showError extends ChangeNotifier {
  bool showText = false;
  void swapState(bool state) {
    showText = state;
    notifyListeners();
  }
}

class Buyable extends ChangeNotifier {
  bool canbuy = true;

  void updateBuyable(bool getcanbuy) {
    canbuy = getcanbuy;
    notifyListeners();
  }
}

class ItemsChar extends ChangeNotifier {
  ShopItems shopItems = ShopItems();

  void updateBuyable(ShopItems getItems) {
    shopItems = getItems;
    notifyListeners();
  }
}

class ItemsBG extends ChangeNotifier {
  ShopItems shopItems = ShopItems();

  void updateBuyable(ShopItems getItems) {
    shopItems = getItems;
    notifyListeners();
  }
}

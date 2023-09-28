import 'dart:convert';
import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:testre/FileHandling/fileHelper.dart';

import '../GamePage/fightPage.dart';
import '../Helper/globals.dart';
import '../ShopPage/shopFile.dart';
import 'fileChar.dart';

PageController _controller = PageController();
int index = 0;
int updateWidth = 0;

class CharPage extends StatefulWidget {
  const CharPage({super.key});

  @override
  State<CharPage> createState() => _CharPageState();
}

Color color1 = Color.fromARGB(161, 212, 0, 205);
Color color2 = Colors.transparent;

class _CharPageState extends State<CharPage> {
  void resolveChars() async {
    String json = await resolveItems();
    Map<String, dynamic> data = jsonDecode(json);
    MyChars obj = await decodeItems();
    const String char = "Char";
    const String bg = "BG";
    for (int i = 0; i < obj.assetCategory.length; i++) {
      if (obj.assetCategory[i] == char) {
        listChars.assetName.add(obj.assetName[i]);
        listChars.assetCategory.add(obj.assetCategory[i]);
        listChars.assetLink.add(obj.assetLink[i]);
        listChars.assetLinkSS.add(obj.assetScreenShots[i]);
      }

      if (obj.assetCategory[i] == bg) {
        listBGs.assetName.add(obj.assetName[i]);
        listBGs.assetCategory.add(obj.assetCategory[i]);
        listBGs.assetLink.add(obj.assetLink[i]);
        listBGs.assetLinkSS.add(obj.assetScreenShots[i]);
      }
    }
    try {
      setState(() {
        listChars = listChars;
      });
    } catch (e) {
      print("CHars Error list line 60");
    }
  }

  ShopItems listChars = ShopItems();
  ShopItems listBGs = ShopItems();
  @override
  void initState() {
    setState(() {
      color1 = Color.fromARGB(161, 212, 0, 205);
      color2 = Colors.transparent;
    });

    resolveChars();
    super.initState();
  }

  bool showchars = true;
  bool showbgs = false;
  bool showborders = false;
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
            child: Container(
              color: objglobals.secondColor,
              height: maxHeight,
              width: maxWidth * 0.6,
              child: AutoSizeText(
                "Ausrüstungslager",
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  'Orbitron', // Replace with your desired Google Font
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: maxWidth * 0.03),
          child: Container(
            height: maxHeight * 0.04,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color1 = objglobals.fourthColor;
                      color2 = Colors.transparent;
                      showchars = true;
                      showbgs = false;
                      showborders = false;
                    });
                  },
                  child: Container(
                    width: maxWidth / 2,
                    height: maxHeight,
                    decoration: BoxDecoration(
                      color: color1,
                      border: Border(
                        left: BorderSide(
                          width: maxHeight * 0.003,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          width: maxWidth * 0.08,
                          child: Image.asset(
                            "3DScreenShot/PilziSS.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      color1 = Colors.transparent;
                      color2 = objglobals.fourthColor;
                      showchars = false;
                      showbgs = true;
                      showborders = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color2,
                      border: Border(
                        left: BorderSide(
                          width: maxHeight * 0.003,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
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
                    width: maxWidth / 2,
                    height: maxHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          width: maxWidth * 0.08,
                          child: Image.asset(
                            "Backgrounds/BG02.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
            width: maxWidth,
            height: maxHeight * 0.4,
            child: Column(
              children: [
                showchars
                    ? Container(
                        width: maxWidth,
                        height: maxHeight * 0.37,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listChars.assetName.length,
                          itemBuilder: (context, index) {
                            return Item(
                              items: listChars,
                              index: index,
                            );
                          },
                        ))
                    : SizedBox(),

                //Bgs
                showbgs
                    ? Container(
                        width: maxWidth,
                        height: maxHeight * 0.37,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listBGs.assetName.length,
                          itemBuilder: (context, index) {
                            return Item(
                              items: listBGs,
                              index: index,
                            );
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            )),

        Container(
          width: maxWidth,
          height: maxHeight * 0.29,
          child: (GetModelViewer(
            getModelPath: context.watch<ModelPath>().modelPath,
            key: UniqueKey(),
          )),
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
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
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
            Container(
              color: objglobals.fourthColor,
              width: maxWidth * 0.6,
              height: maxHeight * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: objglobals.fourthColor),
                onPressed: () async {
                  const String char = "Char";
                  const String bg = "BG";
                  if (widget.items.assetCategory[widget.index] == char &&
                      widget.items.assetLink[widget.index] !=
                          context.read<ModelPath>().modelPath) {
                    context
                        .read<ModelPath>()
                        .changePath(widget.items.assetLink[widget.index]);
                  }

                  if (widget.items.assetCategory[widget.index] == bg) {
                    context
                        .read<BGPath>()
                        .changePath(widget.items.assetLink[widget.index]);
                  }
                  updateSelected(widget.items.assetCategory[widget.index],
                      widget.items.assetLink[widget.index]);
                },
                child: AutoSizeText(
                  "Select",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Orbitron', // Replace with your desired Google Font
                    textStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
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

class GetModelViewer extends StatefulWidget {
  final String getModelPath;
  const GetModelViewer({super.key, required this.getModelPath});

  @override
  State<GetModelViewer> createState() => _GetModelViewerState();
}

class _GetModelViewerState extends State<GetModelViewer> {
  @override
  Widget build(BuildContext context) {
    Globals objglobals = Globals();
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: objglobals.mainColor,
        child: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.fromLTRB(maxWidth * 0.2, 0, maxWidth * 0.2, 0),
              child: Container(
                width: maxWidth,
                child: Image.asset(
                  context.watch<BGPath>().bgPath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              child: ModelViewer(
                src: context.watch<ModelPath>().modelPath,
                alt: 'My 3D Model',
                ar: false, // Enable AR mode
                autoRotate: false, // Enable auto-rotation
                cameraControls: true, // Enable camera controls
                disableTap: true,
                disablePan: true,
                disableZoom: true,
                autoPlay: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

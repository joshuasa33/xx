import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:testre/CharPage/fileChar.dart';
import 'package:testre/ShopPage/ShopUI.dart';

class ShopItems {
  List<String> assetName = [];
  List<String> assetCategory = [];
  List<String> assetLink = [];
  List<String> assetLinkSS = [];
}

Future<void> getItems(BuildContext context) async {
  ShopItems items = ShopItems();
  ShopItems filterChars = ShopItems();
  ShopItems filterBGs = ShopItems();
  ShopItems filterBorders = ShopItems();

  MyChars ownedItems = await decodeItems();
  const String char = "Char";
  const String background = "BG";
  //Chars
  items.assetName = [
    //Chars
    "Pilzi", //1
    "Assasin", //2
    "BlueDuo", //3
    "ColorDuo", //4
    "DeepSea", //5
    "FnFighter", //6
    "thefuture", //7
    //Backgrounds
    "BG01", //1
    "BG02", //2
    "BG03", //3
    "BG04", //4
    "BG05", //5
    "BG06", //6
    "BG00" //7
  ];
  items.assetCategory = [
    char, //1
    char, //2
    char, //3
    char, //4
    char, //5
    char, //6
    char, //7

    //Bg
    background, //1
    background, //2
    background, //3
    background, //4
    background, //5
    background, //6
    background, //7
  ];
  items.assetLink = [
    "3DModels/Pilzi.glb", //1
    "3DModels/Assasin.glb", //2
    "3DModels/BlueDuo.glb", //3
    "3DModels/ColorDuo.glb", //4
    "3DModels/DeepSea.glb", //5
    "3DModels/FnFighter.glb", //6
    "3DModels/thefuture.glb", //7
    //Backgrounds
    "Backgrounds/BG01.jpg", //1
    "Backgrounds/BG02.jpg", //2
    "Backgrounds/BG03.jpg", //3
    "Backgrounds/BG04.jpg", //4
    "Backgrounds/BG05.jpg", //5
    "Backgrounds/BG06.jpg", //6
    "Backgrounds/BG00.jpg" //7
  ];
  items.assetLinkSS = [
    "3DScreenShot/PilziSS.png", //1
    "3DScreenShot/AssasinSS.png", //2
    "3DScreenShot/BlueDuoSS.png", //3
    "3DScreenShot/ColorDuoSS.png", //4
    "3DScreenShot/DeepSeaSS.png", //5
    "3DScreenShot/FnFighterSS.png", //6
    "3DScreenShot/thefutureSS.png", //7
    //Backgrounds
    "Backgrounds/BG01.jpg", //1
    "Backgrounds/BG02.jpg", //2
    "Backgrounds/BG03.jpg", //3
    "Backgrounds/BG04.jpg", //4
    "Backgrounds/BG05.jpg", //5
    "Backgrounds/BG06.jpg", //6
    "Backgrounds/BG00.jpg" //6
  ];
  //Backgrounds

  //Filter owned items from available shop items
  int counter = 0;
  for (int i = 0; i < ownedItems.assetName.length; i++) {
    int index = items.assetName.indexOf(ownedItems.assetName[i]);
    items.assetName.removeAt(index);
    items.assetCategory.removeAt(index);
    items.assetLink.removeAt(index);
    items.assetLinkSS.removeAt(index);
  }
  // FILTER Items to specific category
  for (int i = 0; i < items.assetName.length; i++) {
    if (items.assetCategory[i] == char) {
      filterChars.assetName.add(items.assetName[i]);
      filterChars.assetCategory.add(items.assetCategory[i]);
      filterChars.assetLink.add(items.assetLink[i]);
      filterChars.assetLinkSS.add(items.assetLinkSS[i]);
    }
    if (items.assetCategory[i] == background) {
      filterBGs.assetName.add(items.assetName[i]);
      filterBGs.assetCategory.add(items.assetCategory[i]);
      filterBGs.assetLink.add(items.assetLink[i]);
      filterBGs.assetLinkSS.add(items.assetLinkSS[i]);
    }
  }
  context.read<ItemsBG>().updateBuyable(filterBGs);
  context.read<ItemsChar>().updateBuyable(filterChars);
}

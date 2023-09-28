import 'dart:convert';

import '../FileHandling/fileHelper.dart';

class MyChars {
  List<String> assetName = ["Pilzi", "BG00"];
  List<String> assetCategory = ["Char", "BG"];
  List<String> assetLink = ["3DModels/Pilzi.glb", "Backgrounds/BG00.jpg"];
  List<String> assetScreenShots = [
    "3DScreenShot/PilziSS.png",
    "Backgrounds/BG00.jpg"
  ];
  String currentChar = "3DModels/Pilzi.glb";
  String currentBackground = "Backgrounds/BG00.jpg";
  String currentBorder = "Border00";
  bool rotate = false;
  String rotationSpeed = "0.5rad";

  String toJson() {
    Map<String, dynamic> jsonMap = {
      'assetName': assetName,
      'assetCategory': assetCategory,
      'assetLink': assetLink,
      'assetScreenShots': assetScreenShots,
      'currentChar': currentChar,
      'currentBackground': currentBackground,
      'currentBorder': currentBorder,
      'rotate': rotate,
      'rotationSpeed': rotationSpeed,
    };

    return json.encode(jsonMap);
  }
}

Future<String> resolveItems() async {
  //Check if intern file exist else create it
  const String jsonItems = "jsonMyItems.txt";
  if (await fileExists(jsonItems) == false) {
    MyChars myRaeume = MyChars();

    String json = myRaeume.toJson();
    await writeData(json, jsonItems);
    return json;
  } else {
    String json = await retrieveData(jsonItems);
    return json;
  }
}

Future<void> addItem(String getassetName, String getCategory,
    String getassetLink, String getassetScreenShots) async {
  const String jsonItems = "jsonMyItems.txt";

  MyChars obj = await decodeItems();
  int index = obj.assetName.indexOf(getassetName);
  if (index == -1) {
    //Add to file
    obj.assetName.add(getassetName);
    obj.assetCategory.add(getCategory);
    obj.assetLink.add(getassetLink);
    obj.assetScreenShots.add(getassetScreenShots);
  } else {
    //NOt add already inside
  }

  String newJson = obj.toJson();
  await writeData(newJson, jsonItems);
}

Future<MyChars> decodeItems() async {
  String json = await resolveItems();
  Map<String, dynamic> data = jsonDecode(json);
  MyChars obj = MyChars()
    ..assetName = List<String>.from(data['assetName'])
    ..assetCategory = List<String>.from(data['assetCategory'])
    ..assetLink = List<String>.from(data['assetLink'])
    ..assetScreenShots = List<String>.from(data['assetScreenShots'])
    ..currentChar = data['currentChar']
    ..currentBackground = data['currentBackground']
    ..currentBorder = data['currentBorder']
    ..rotate = data['rotate']
    ..rotationSpeed = data['rotationSpeed'];
  return obj;
}

Future<void> updateSelected(String category, String assetpath) async {
  const String jsonItems = "jsonMyItems.txt";
  MyChars obj = await decodeItems();
  if (category == "Char") {
    obj.currentChar = assetpath;
  }
  if (category == "BG") {
    obj.currentBackground = assetpath;
  }
  String newJson = obj.toJson();
  writeData(newJson, jsonItems);
}

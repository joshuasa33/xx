import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:testre/GamePage/fightPage.dart';

class GlobalModel extends StatefulWidget {
  final bool isEnemy;
  const GlobalModel({
    super.key,
    required this.isEnemy,
  });

  @override
  State<GlobalModel> createState() => _GlobalModelState();
}

class _GlobalModelState extends State<GlobalModel> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool isForeground = state == AppLifecycleState.resumed;
    setState(() {
      isForeground = isForeground;
      context.read<IsForeground>().setForeground(isForeground);
      print("$isForeground +foreground re");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<ModelPath>().modelPath != "" &&
          mounted &&
          context.watch<IsForeground>().appIsForeground,
      child: ModelViewer(
        loading: Loading.lazy,
        src: !widget.isEnemy
            ? context.watch<ModelPath>().modelPath
            : context.watch<ModelPathEnemy>().modelPath,
        alt: 'My 3D Model',
        disableZoom: true,
        cameraControls: true, // Enable camera controls
        disableTap: true,
        disablePan: true,
      ),
    );
  }
}

class IsForeground extends ChangeNotifier {
  bool appIsForeground = true;
  void setForeground(bool value) {
    appIsForeground = value;
    notifyListeners();
  }
}

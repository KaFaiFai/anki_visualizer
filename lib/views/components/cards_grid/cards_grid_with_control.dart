import 'package:anki_visualizer/controller/routes.dart';
import 'package:anki_visualizer/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../models/animation_preference.dart';
import '../../../models/card_log.dart';
import '../../basic/capturable.dart';
import 'cards_grid_2.dart';

class CardsGridWithControl extends StatefulWidget {
  final List<CardLog> cardLogs;
  final AnimationPreference preference;
  final String captureFolder;

  const CardsGridWithControl(
      {super.key, required this.cardLogs, required this.preference, required this.captureFolder});

  @override
  State<CardsGridWithControl> createState() => _CardsGridWithControlState();
}

class _CardsGridWithControlState extends State<CardsGridWithControl> {
  final GlobalKey<CapturableState> _capturableKey = GlobalKey<CapturableState>();
  final GlobalKey<CardsGrid2State> _cardsGrid2Key = GlobalKey<CardsGrid2State>();
  int _count = 0;
  double? lastAnimationValue;

  AnimationController? get animationController => _cardsGrid2Key.currentState?.animationController;

  Widget buildControlRow(BuildContext context) {
    return PaddedRow(
      padding: 10,
      children: [
        IconButton(
          iconSize: 40,
          onPressed: onPressRestart,
          icon: const Icon(Icons.replay),
        ),
        IconButton(
          iconSize: 40,
          onPressed: onPressPlay,
          icon: const Icon(Icons.play_arrow),
        ),
        IconButton(
          iconSize: 40,
          onPressed: onPressPause,
          icon: const Icon(Icons.pause),
        ),
        Expanded(
          child: Slider(
            value: animationController?.value ?? 0,
            min: animationController?.lowerBound ?? 0,
            max: animationController?.upperBound ?? 1,
            label: lastAnimationValue?.toStringAsPrecision(4),
            onChanged: (double value) {
              setState(() {
                animationController?.value = value;
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildControlRow(context)),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _count == 0 ? null : () => Navigator.of(context).pushNamed(Routes.exportPage),
                child: const Text("Export"),
              ),
            ],
          ),
        ),
        Expanded(
          child: Capturable(
            key: _capturableKey,
            child: CardsGrid2(key: _cardsGrid2Key, cardLogs: widget.cardLogs, preference: widget.preference),
          ),
        ),
      ],
    );
  }

  void onPressRestart() {
    _cardsGrid2Key.currentState?.resetState();
  }

  void onPressPlay() {
    animationController?.addListener(_captureScreen);
    animationController?.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          print("Animation started");
        case AnimationStatus.completed:
          animationController?.removeListener(_captureScreen);
          print("Animation ended");
        default:
      }
    });
    _cardsGrid2Key.currentState?.playProgress();
  }

  void onPressPause() {
    animationController?.stop();
    animationController?.removeListener(_captureScreen);
  }

  void _captureScreen() {
    // animationController.addListener will trigger twice at start for some reason. This is an attempt to fix it
    if (animationController?.value != lastAnimationValue) {
      final saveTo = join(widget.captureFolder, "image-${_count.toString().padLeft(7, '0')}.png");
      _capturableKey.currentState?.captureAndSave(saveTo);
      _count++;
    }
    lastAnimationValue = animationController?.value;
    setState(() {});
  }
}

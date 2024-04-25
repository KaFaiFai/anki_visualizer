import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../models/animation_preference.dart';
import '../../models/card_log.dart';
import '../basic/capturable.dart';
import 'cards_grid.dart';

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
  final GlobalKey<CardsGridState> _cardsGridKey = GlobalKey<CardsGridState>();
  int _count = 0;
  double? lastAnimationValue;

  ScrollController? get scrollController => _cardsGridKey.currentState?.scrollController;

  AnimationController? get animationController => _cardsGridKey.currentState?.animationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaddedRow(
          padding: 10,
          children: [
            IconButton(
              onPressed: onPressRestart,
              icon: const Icon(Icons.replay),
            ),
            IconButton(
              onPressed: onPressPlay,
              icon: const Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: onPressPause,
              icon: const Icon(Icons.pause),
            ),
            Slider(
              value: animationController?.value ?? 0,
              min: animationController?.lowerBound ?? 0,
              max: animationController?.upperBound ?? 1,
              label: lastAnimationValue?.toStringAsPrecision(4),
              onChanged: (double value) {
                setState(() {
                  animationController?.value = value;
                });
              },
            )
          ],
        ),
        Expanded(
          child: Capturable(
            key: _capturableKey,
            child: CardsGrid(key: _cardsGridKey, cardLogs: widget.cardLogs, preference: widget.preference),
          ),
        ),
      ],
    );
  }

  void onPressRestart() {
    _cardsGridKey.currentState?.resetState();
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
    _cardsGridKey.currentState?.playProgress();
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
    setState(() => lastAnimationValue = animationController?.value);
  }
}

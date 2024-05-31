import 'package:anki_visualizer/controller/routes.dart';
import 'package:anki_visualizer/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../models/animation_preference.dart';
import '../../../models/card_log.dart';
import '../../../models/log.dart';
import '../../basic/capturable.dart';
import 'cards_grid_2.dart';

class CardsGridWithControl extends StatefulWidget {
  final List<CardLog> cardLogs;
  final AnimationPreference preference;
  final String captureFolder;

  CardsGridWithControl(
      {super.key, required this.cardLogs, required this.preference, required this.captureFolder});

  @override
  State<CardsGridWithControl> createState() => _CardsGridWithControlState();
}

class _CardsGridWithControlState extends State<CardsGridWithControl> {
  final GlobalKey<CapturableState> _capturableKey = GlobalKey<CapturableState>();
  final GlobalKey<CardsGrid2State> _cardsGrid2Key = GlobalKey<CardsGrid2State>();
  int _count = 0;
  double? lastAnimationValue;
  static const defaultFontSize = 12.0;
  static const defaultMaxWidth = 50.0;
  double fontSize = defaultFontSize;
  double maxWidth = defaultMaxWidth;

  late TextEditingController fontSizeController;
  late TextEditingController maxWidthController;
  late FocusNode fontSizeFocusNode;
  late FocusNode maxWidthFocusNode;

  AnimationController? get animationController => _cardsGrid2Key.currentState?.animationController;

  @override
  void initState() {
    super.initState();
    fontSizeController = TextEditingController(text: fontSize.toString());
    maxWidthController = TextEditingController(text: maxWidth.toString());
    fontSizeFocusNode = FocusNode();
    maxWidthFocusNode = FocusNode();

    fontSizeFocusNode.addListener(() {
      if (!fontSizeFocusNode.hasFocus) {
        setState(() {
          fontSize = double.tryParse(fontSizeController.text) ?? defaultFontSize;
        });
      }
    });

    maxWidthFocusNode.addListener(() {
      if (!maxWidthFocusNode.hasFocus) {
        setState(() {
          maxWidth = double.tryParse(maxWidthController.text) ?? defaultMaxWidth;
        });
      }
    });
  }

  @override
  void dispose() {
    fontSizeController.dispose();
    maxWidthController.dispose();
    fontSizeFocusNode.dispose();
    maxWidthFocusNode.dispose();
    super.dispose();
  }

  Widget buildControlRow(BuildContext context) {
    const textStyle =  TextStyle(fontSize: 16.0);
    return PaddedRow(
      padding: 10,
      children: [
        Column(
          children: [
            Row(
              children: [
                const Text("fontSize", style: textStyle),
                SizedBox(
                  width: 75, // 添加宽度约束
                  height: 35,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                    controller: fontSizeController,
                    focusNode: fontSizeFocusNode,
                    style: textStyle
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text("maxLen", style: textStyle),
                SizedBox(
                  width: 75, // 添加宽度约束
                  height: 35,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                    controller: maxWidthController,
                    focusNode: maxWidthFocusNode,
                    style: textStyle
                  ),
                ),
              ],
            ),
          ],
        ),
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
            child: CardsGrid2(key: _cardsGrid2Key, cardLogs: widget.cardLogs, preference: widget.preference,fontSize: fontSize,
                    maxWidth: maxWidth),
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
          Log.logger.i("Animation started");
        case AnimationStatus.completed:
          animationController?.removeListener(_captureScreen);
          Log.logger.i("Animation ended");
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

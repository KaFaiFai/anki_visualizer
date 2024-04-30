import 'package:anki_visualizer/models/animation_preference.dart';
import 'package:flutter/material.dart';

import '../models/log.dart';

class PreferenceModel extends ChangeNotifier {
  AnimationPreference? preference;

  PreferenceModel();

  void updatePreference(AnimationPreference? preference) {
    Log.logger.t("Selected preference: $preference");
    this.preference = preference;
    notifyListeners();
  }
}

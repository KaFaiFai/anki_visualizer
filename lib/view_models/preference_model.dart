import 'package:anki_progress/models/animation_preference.dart';
import 'package:flutter/material.dart';

class PreferenceModel extends ChangeNotifier {
  AnimationPreference? preference;

  PreferenceModel();

  void updatePreference(AnimationPreference? preference) {
    print(preference);
    this.preference = preference;
    notifyListeners();
  }
}

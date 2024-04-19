import 'package:anki_progress/models/preference.dart';
import 'package:flutter/material.dart';

class PreferenceModel extends ChangeNotifier {
  Preference? preference;

  PreferenceModel({this.preference});

  void updatePreference(Preference? preference) {
    print(preference);
    this.preference = preference;
  }
}

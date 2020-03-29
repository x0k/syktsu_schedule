import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

import '../constants.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: PreferencePage([
        SwitchPreference(
          'Оффлайн режим',
          OFFLINE_MODE,
        )
      ]),
    );
  }
}

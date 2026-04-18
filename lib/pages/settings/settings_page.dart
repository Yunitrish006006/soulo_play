import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_ui_settings/user_ui_settings.dart';
import '../../widgets/settings_panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LocaleProvider>().translation;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.text('Settings')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: const [
              SettingsPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

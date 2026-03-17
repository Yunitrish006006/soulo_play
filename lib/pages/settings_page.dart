import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Font size'),
            Slider(
              value: settings.fontScale,
              min: 0.7,
              max: 1.6,
              divisions: 9,
              label: settings.fontScale.toStringAsFixed(2),
              onChanged: (v) => settings.setFontScale(v),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark mode'),
                Switch(
                  value: settings.isDark,
                  onChanged: (v) => settings.toggleDark(v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

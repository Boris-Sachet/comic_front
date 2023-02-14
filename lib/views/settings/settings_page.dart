import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:comic_front/services/service_settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text("UI"),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  title: const Text('Enable dark mode'),
                  description: ServiceSettings.darkMode ? const Text('Dark mode') : const Text('Light mode'),
                  initialValue: ServiceSettings.darkMode,
                  onToggle: (bool value) {
                    setState(() {
                      ServiceSettings.darkMode = !ServiceSettings.darkMode;
                    });
                    ServiceSettings.darkMode ? AdaptiveTheme.of(context).setDark() : AdaptiveTheme.of(context).setLight();
                  },
                )
              ],
            ),
            SettingsSection(
              title: const Text("Libraries"),
              tiles: <SettingsTile>[
                SettingsTile.switchTile(
                  title: const Text('Show hidden libraries'),
                  initialValue: ServiceSettings.showHiddenLibraries,
                  onToggle: (bool value) {
                    setState(() {
                      ServiceSettings.showHiddenLibraries = !ServiceSettings.showHiddenLibraries;
                    });
                  },
                )
              ],
            )
          ],
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:generateur_de_recu/screens/profile.dart';
import 'package:settings_ui/settings_ui.dart';

import '../constants/widgets.dart';
import 'creatte_invoice.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Profile'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    )
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Interface'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Langue'),
                value: Text('Français'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

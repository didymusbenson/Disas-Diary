import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// Settings screen with theme preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'THEME',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Use system theme toggle
          SwitchListTile(
            title: const Text('Use System Theme'),
            subtitle: const Text('Follow system light/dark mode setting'),
            value: appState.useSystemTheme,
            onChanged: (value) {
              appState.setUseSystemTheme(value);
            },
          ),

          // Use dark mode toggle
          SwitchListTile(
            title: const Text('Use Dark Mode'),
            subtitle: appState.useSystemTheme
                ? const Text('Disabled when using system theme')
                : const Text('Manually enable dark mode'),
            value: appState.useDarkMode,
            onChanged: appState.useSystemTheme
                ? null // Disable when system theme is on
                : (value) {
                    appState.setUseDarkMode(value);
                  },
          ),

          const Divider(),

          // Future settings can go here
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/artwork_cache.dart';

/// Settings screen with theme preferences and storage management.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _cacheSize = 0;
  bool _loadingSize = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await ArtworkCache.getTotalCacheSize();
    if (mounted) {
      setState(() {
        _cacheSize = size;
        _loadingSize = false;
      });
    }
  }

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

          // Storage section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'STORAGE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),

          // Cache size display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Downloaded Artwork',
                  style: theme.textTheme.bodyLarge,
                ),
                _loadingSize
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        ArtworkCache.formatSize(_cacheSize),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ],
            ),
          ),

          // Clear cache button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton(
              onPressed: _cacheSize == 0 || _loadingSize
                  ? null
                  : () => _showClearCacheDialog(context),
              child: const Text('Clear Downloaded Artwork'),
            ),
          ),

          const Divider(),

          // Future settings can go here
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear artwork cache?'),
        content: const Text(
          'This will delete all downloaded card images. They will be re-downloaded when needed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ArtworkCache.clearAll();
              _loadCacheSize();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

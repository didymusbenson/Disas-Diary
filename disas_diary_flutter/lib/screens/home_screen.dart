import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about_screen.dart';
import 'attractions_screen.dart';
import 'command_zone_screen.dart';
import 'disas_diary_screen.dart';
import 'dice_bag_screen.dart';
import 'dungeons_screen.dart';
import 'mana_pool_screen.dart';
import 'settings_screen.dart';

/// Home screen - toolkit menu listing all available tools
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(
          "Disa's Diary",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20),
            tooltip: 'About',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            tooltip: 'Settings',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          children: [
            _ToolListItem(
              title: "Disa's Diary",
              subtitle: 'Tarmogoyf P/T tracker & graveyard card types',
              icon: Icons.auto_stories,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisasDiaryScreen(),
                ),
              ),
            ),
            _ToolListItem(
              title: 'Mana Pool',
              subtitle: 'Track available mana across colors',
              icon: Icons.water_drop,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManaPoolScreen(),
                ),
              ),
            ),
            _ToolListItem(
              title: 'Command Zone',
              subtitle: 'Advanced life tracker',
              icon: Icons.shield,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommandZoneScreen(),
                ),
              ),
            ),
            _ToolListItem(
              title: 'Dungeons',
              subtitle: 'Dungeon progress tracking',
              icon: Icons.door_front_door,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DungeonsScreen(),
                ),
              ),
            ),
            _ToolListItem(
              title: 'Attractions Deck',
              subtitle: 'Attraction management for Unfinity',
              icon: Icons.attractions,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttractionsScreen(),
                ),
              ),
            ),
            _ToolListItem(
              title: 'Dice Bag',
              subtitle: 'Roll d6 with card-specific shortcuts',
              icon: Icons.casino,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiceBagScreen(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'More Tools',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const _ExternalAppItem(
              title: 'French Vanilla',
              subtitle: 'Searchable Magic rulebook',
              icon: Icons.menu_book,
              appStoreId: '6758114292',
              bundleId: 'LooseTie.Frenchvanilla',
            ),
            const _ExternalAppItem(
              title: 'Tripling Season',
              subtitle: 'Token & board state manager',
              icon: Icons.copy_all,
              appStoreId: '6560103966',
              bundleId: 'LooseTie.Doubling-Season',
            ),
          ],
        ),
      ),
    );
  }

}

class _ExternalAppItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String appStoreId;
  final String bundleId;

  const _ExternalAppItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.appStoreId,
    required this.bundleId,
  });

  Future<void> _launch(BuildContext context) async {
    Uri uri;

    if (kIsWeb) {
      // Web: link to App Store page
      uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    } else if (Platform.isIOS) {
      // iOS: try to open the app, fall back to App Store
      final appUri = Uri.parse('$bundleId://');
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
        return;
      }
      uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    } else if (Platform.isAndroid) {
      // Android: link to App Store (no Play Store listings exist)
      uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    } else {
      uri = Uri.parse('https://apps.apple.com/app/id$appStoreId');
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.open_in_new, size: 18, color: theme.colorScheme.onSurfaceVariant),
        onTap: () => _launch(context),
      ),
    );
  }
}

class _ToolListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        onTap: onTap,
      ),
    );
  }
}

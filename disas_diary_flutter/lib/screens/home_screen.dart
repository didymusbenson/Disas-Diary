import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'attractions_screen.dart';
import 'command_zone_screen.dart';
import 'disas_diary_screen.dart';
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
          'Mana Burn',
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
          ],
        ),
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

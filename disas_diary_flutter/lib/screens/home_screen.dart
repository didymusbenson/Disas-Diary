import 'package:flutter/material.dart';
import 'attractions_screen.dart';
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
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, size: 20),
            tooltip: 'About',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _showAboutDialog(context),
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

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mana Burn',
      applicationVersion: '2.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'web/icons/Icon-192.png',
          width: 64,
          height: 64,
        ),
      ),
      children: [
        const Text(
          'A Magic: The Gathering toolkit for gameplay tracking.',
        ),
        const SizedBox(height: 8),
        const Text(
          "Disa's Diary: Tarmogoyf P/T calculator and graveyard card type tracker.",
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2024 Didymus Benson. All rights reserved.',
          style: TextStyle(fontSize: 12),
        ),
      ],
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

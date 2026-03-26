import 'package:flutter/material.dart';

/// Dungeons tool screen - Dungeon progress tracking
class DungeonsScreen extends StatelessWidget {
  const DungeonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dungeons',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text('Coming soon'),
      ),
    );
  }
}

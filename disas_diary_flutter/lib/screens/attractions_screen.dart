import 'package:flutter/material.dart';

/// Attractions Deck tool screen - Attraction management for Unfinity mechanics
class AttractionsScreen extends StatelessWidget {
  const AttractionsScreen({super.key});

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
          'Attractions Deck',
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

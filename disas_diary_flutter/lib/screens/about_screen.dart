import 'package:flutter/material.dart';

/// Full-screen About page with app info, licenses, and legal disclaimers
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // App icon and name
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'web/icons/Icon-192.png',
                      width: 64,
                      height: 64,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mana Burn',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 2.0.0',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A Magic: The Gathering toolkit for gameplay tracking.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Legal disclaimer
            Text(
              'Legal',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Magic: The Gathering is a trademark of Wizards of the Coast. '
              'Mana symbols and card type symbols are copyright Wizards of the Coast. '
              'This app is not produced by, endorsed by, supported by, or affiliated '
              'with Wizards of the Coast.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Didymus Benson. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Open source licenses
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.description_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Open Source Licenses'),
                subtitle: const Text('View package attributions'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Mana Burn',
                    applicationVersion: '2.0.0',
                    applicationIcon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'web/icons/Icon-192.png',
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

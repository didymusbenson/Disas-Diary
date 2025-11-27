import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/token_view.dart';
import '../widgets/grave_stepper.dart';

/// Main home screen with Tarmogoyf tracker and card type toggles
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final item = appState.item;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Reset All',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _showResetDialog(context, appState),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Column(
            children: [
              // Token View
              if (item != null) TokenView(item: item),

              const SizedBox(height: 8),

              // Your Graveyard Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'YOUR GRAVEYARD',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Row 0: Creature & Artifact
              Row(
                children: [
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Creature', 'creature'),
                  ),
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Artifact', 'artifact'),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Row 1: Enchantment & Instant
              Row(
                children: [
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Enchantment', 'enchantment'),
                  ),
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Instant', 'instant'),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Row 2: Sorcery & Land
              Row(
                children: [
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Sorcery', 'sorcery'),
                  ),
                  Expanded(
                    child:
                        _buildCardTypeToggle(context, appState, 'Land', 'land'),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Row 3: Planeswalker & Battle
              Row(
                children: [
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Planeswalker', 'planeswalker'),
                  ),
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Battle', 'battle'),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Row 4: Kindred
              Row(
                children: [
                  Expanded(
                    child: _buildCardTypeToggle(
                        context, appState, 'Kindred', 'kindred'),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Graveyard Trackers Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'GRAVEYARD TRACKERS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              // Grave Steppers - 2 per row
              ...List.generate(
                (appState.graveSteppers.length / 2).ceil(),
                (rowIndex) {
                  final leftIndex = rowIndex * 2;
                  final rightIndex = leftIndex + 1;

                  return Row(
                    children: [
                      Expanded(
                        child: GraveStepper(
                          name: appState.graveSteppers[leftIndex].name,
                          value: appState.graveSteppers[leftIndex].value,
                          onIncrement: () => appState.incrementGraveStepper(leftIndex),
                          onDecrement: () => appState.decrementGraveStepper(leftIndex),
                        ),
                      ),
                      if (rightIndex < appState.graveSteppers.length)
                        Expanded(
                          child: GraveStepper(
                            name: appState.graveSteppers[rightIndex].name,
                            value: appState.graveSteppers[rightIndex].value,
                            onIncrement: () => appState.incrementGraveStepper(rightIndex),
                            onDecrement: () => appState.decrementGraveStepper(rightIndex),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a card type toggle button
  Widget _buildCardTypeToggle(
    BuildContext context,
    AppState appState,
    String label,
    String type,
  ) {
    final isSelected = appState.cardTypes[type] ?? false;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: FilledButton.tonal(
        onPressed: () => appState.setCardType(type, !isSelected),
        style: FilledButton.styleFrom(
          backgroundColor: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          foregroundColor: isSelected
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : BorderSide.none,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Show reset confirmation dialog
  void _showResetDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All'),
        content: const Text(
          'This will reset all card type toggles, token counts, and grave stepper values to their defaults. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              appState.resetAll();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

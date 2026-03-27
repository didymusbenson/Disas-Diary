import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/mtg_colors.dart';
import '../widgets/mana_icons.dart';
import '../widgets/mana_tile.dart';

class _ManaDefinition {
  final String symbol;
  final String name;
  final Color color;
  final Color symbolColor;
  final IconData icon;
  final Offset symbolOffset;

  const _ManaDefinition({
    required this.symbol,
    required this.name,
    required this.color,
    required this.symbolColor,
    required this.icon,
    this.symbolOffset = Offset.zero,
  });
}

/// Mana Pool tool screen - Track available mana across colors
class ManaPoolScreen extends StatefulWidget {
  const ManaPoolScreen({super.key});

  @override
  State<ManaPoolScreen> createState() => _ManaPoolScreenState();
}

class _ManaPoolScreenState extends State<ManaPoolScreen> {
  ManaPoolMode _mode = ManaPoolMode.normal;

  static const List<_ManaDefinition> _manaTypes = [
    _ManaDefinition(symbol: 'W', name: 'White', color: MtgColors.white, symbolColor: MtgColors.whiteSymbol, icon: ManaIcons.white, symbolOffset: Offset(0, -0.03)),
    _ManaDefinition(symbol: 'U', name: 'Blue', color: MtgColors.blue, symbolColor: MtgColors.blueSymbol, icon: ManaIcons.blue, symbolOffset: Offset(0, -0.03)),
    _ManaDefinition(symbol: 'B', name: 'Black', color: MtgColors.black, symbolColor: MtgColors.blackSymbol, icon: ManaIcons.black, symbolOffset: Offset(0, -0.03)),
    _ManaDefinition(symbol: 'R', name: 'Red', color: MtgColors.red, symbolColor: MtgColors.redSymbol, icon: ManaIcons.red, symbolOffset: Offset(0, -0.03)),
    _ManaDefinition(symbol: 'G', name: 'Green', color: MtgColors.green, symbolColor: MtgColors.greenSymbol, icon: ManaIcons.green, symbolOffset: Offset(0, -0.03)),
    _ManaDefinition(symbol: 'C', name: 'Colorless', color: MtgColors.colorless, symbolColor: MtgColors.colorlessSymbol, icon: ManaIcons.colorless, symbolOffset: Offset(0, -0.03)),
  ];

  void _showEmptyDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Empty mana pool?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              appState.emptyManaPool();
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _toggleLockMode() {
    setState(() {
      _mode = _mode == ManaPoolMode.lock
          ? ManaPoolMode.normal
          : ManaPoolMode.lock;
    });
  }

  void _toggleConvertMode() {
    setState(() {
      _mode = _mode == ManaPoolMode.convert
          ? ManaPoolMode.normal
          : ManaPoolMode.convert;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mana Pool',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Lock mode toggle
          IconButton(
            icon: Icon(
              _mode == ManaPoolMode.lock ? Icons.lock : Icons.lock_outline,
              size: 20,
            ),
            onPressed: _toggleLockMode,
            tooltip: 'Lock mode',
          ),
          // Empty mana pool
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => _showEmptyDialog(context, appState),
            tooltip: 'Empty mana pool',
          ),
          // Convert to color
          IconButton(
            icon: Icon(
              _mode == ManaPoolMode.convert
                  ? Icons.palette
                  : Icons.palette_outlined,
              size: 20,
            ),
            onPressed: _toggleConvertMode,
            tooltip: 'Convert to color',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              for (int row = 0; row < 3; row++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        for (int col = 0; col < 2; col++)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: _buildManaTile(
                                appState,
                                _manaTypes[row * 2 + col],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManaTile(AppState appState, _ManaDefinition mana) {
    return ManaTile(
      colorSymbol: mana.symbol,
      colorName: mana.name,
      backgroundColor: mana.color,
      symbolColor: mana.symbolColor,
      icon: mana.icon,
      symbolOffset: mana.symbolOffset,
      value: appState.manaPoolCounts[mana.symbol] ?? 0,
      isLocked: appState.manaPoolLocks[mana.symbol] ?? false,
      mode: _mode,
      onIncrement: () => appState.incrementMana(mana.symbol, 1),
      onDecrement: () => appState.decrementMana(mana.symbol, 1),
      onIncrementLarge: () => appState.incrementMana(mana.symbol, 10),
      onDecrementLarge: () => appState.decrementMana(mana.symbol, 10),
      onToggleLock: () => appState.toggleManaLock(mana.symbol),
      onConvert: () {
        appState.convertToColor(mana.symbol);
        setState(() => _mode = ManaPoolMode.normal);
      },
    );
  }
}

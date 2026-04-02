import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dice Bag tool screen — Roll X d6 with card-specific shortcuts
class DiceBagScreen extends StatefulWidget {
  const DiceBagScreen({super.key});

  static const double _appBarHeight = 40;
  static const double _dieSize = 48;
  static const double _dieSpacing = 6;
  static const double _dieBorderRadius = 8;
  static const double _sectionSpacing = 16;
  static const double _contentPadding = 16;
  static const int _minDice = 1;
  static const int _maxDice = 50;
  static const int _defaultDice = 1;

  @override
  State<DiceBagScreen> createState() => _DiceBagScreenState();
}

class _DiceBagScreenState extends State<DiceBagScreen> {
  static const List<String> _dieFaces = ['⚀', '⚁', '⚂', '⚃', '⚄', '⚅'];

  final _random = Random();
  int _diceCount = DiceBagScreen._defaultDice;
  List<int> _results = [];
  String? _activeCard; // null = general, or card name

  void _roll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _results = List.generate(_diceCount, (_) => _random.nextInt(6) + 1);
    });
  }

  void _rollForCard(String cardName, int count) {
    HapticFeedback.mediumImpact();
    setState(() {
      _diceCount = count;
      _activeCard = cardName;
      _results = List.generate(count, (_) => _random.nextInt(6) + 1);
    });
  }

  void _rollGeneral() {
    setState(() {
      _activeCard = null;
    });
    _roll();
  }

  void _setDiceCount(int count) {
    setState(() {
      _diceCount = count.clamp(DiceBagScreen._minDice, DiceBagScreen._maxDice);
      _results = [];
      _activeCard = null;
    });
  }

  // --- Summary helpers ---

  int get _evenCount => _results.where((d) => d.isEven).length;
  int get _oddCount => _results.where((d) => d.isOdd).length;
  int _countOf(int face) => _results.where((d) => d == face).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: DiceBagScreen._appBarHeight,
        title: Text(
          'Dice Bag',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DiceBagScreen._contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- General Dice Roller ---
              _buildDiceInput(theme),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _rollGeneral,
                child: Text('Roll $_diceCount d6'),
              ),
              if (_results.isNotEmpty) ...[
                const SizedBox(height: DiceBagScreen._sectionSpacing),
                _buildSummary(theme),
                if (_activeCard != null) ...[
                  const SizedBox(height: 12),
                  _buildCardResults(theme),
                ],
              ],
              const SizedBox(height: DiceBagScreen._sectionSpacing * 2),
              // --- Card Shortcuts ---
              Text(
                'Card Shortcuts',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              _CardShortcut(
                title: 'Luck Bobblehead',
                inputLabel: 'Bobbleheads controlled',
                onRoll: (count) => _rollForCard('luck_bobblehead', count),
              ),
              const SizedBox(height: 8),
              _CardShortcut(
                title: 'Clown Car',
                inputLabel: 'X value (mana spent)',
                onRoll: (count) => _rollForCard('clown_car', count),
              ),
              const SizedBox(height: 8),
              _CardShortcut(
                title: 'Attempted Murder',
                inputLabel: 'X value',
                onRoll: (count) => _rollForCard('attempted_murder', count),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiceInput(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _diceCount > DiceBagScreen._minDice
              ? () => _setDiceCount(_diceCount - 1)
              : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '$_diceCount',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: _diceCount < DiceBagScreen._maxDice
              ? () => _setDiceCount(_diceCount + 1)
              : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
        Text(
          'd6',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showResultsModal(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(DiceBagScreen._contentPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Roll Results',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: DiceBagScreen._dieSpacing,
                runSpacing: DiceBagScreen._dieSpacing,
                alignment: WrapAlignment.center,
                children: _results.map((die) {
                  final isEven = die.isEven;
                  return Container(
                    width: DiceBagScreen._dieSize,
                    height: DiceBagScreen._dieSize,
                    decoration: BoxDecoration(
                      color: isEven
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(DiceBagScreen._dieBorderRadius),
                      border: Border.all(
                        color: isEven
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        die.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isEven
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummary(ThemeData theme) {
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final valueStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final dieGlyphStyle = theme.textTheme.headlineSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(DiceBagScreen._dieBorderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Even: ', style: labelStyle),
              Text('$_evenCount', style: valueStyle),
              const SizedBox(width: 16),
              Text('Odd: ', style: labelStyle),
              Text('$_oddCount', style: valueStyle),
              const SizedBox(width: 16),
              FilledButton.tonal(
                onPressed: () => _showResultsModal(context, theme),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('See Results'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (i) {
              final face = i + 1;
              return Column(
                children: [
                  Text(_dieFaces[i], style: dieGlyphStyle),
                  Text('${_countOf(face)}', style: valueStyle),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResults(ThemeData theme) {
    final resultStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final winStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w900,
      color: theme.colorScheme.primary,
    );

    final items = <Widget>[];

    switch (_activeCard) {
      case 'luck_bobblehead':
        items.add(Text('Create $_evenCount tapped Treasure tokens', style: resultStyle));
        if (_countOf(6) == 7) {
          items.add(const SizedBox(height: 8));
          items.add(Text('You win the game!', style: winStyle));
        }
        break;
      case 'clown_car':
        items.add(Text('Create $_oddCount Clown Robot tokens', style: resultStyle));
        items.add(const SizedBox(height: 4));
        items.add(Text('Put $_evenCount +1/+1 counters on Clown Car', style: resultStyle));
        break;
      case 'attempted_murder':
        final counters = _evenCount * 2;
        items.add(Text('Put $counters -1/-1 counters on target creature', style: resultStyle));
        items.add(const SizedBox(height: 4));
        items.add(Text('Create $_oddCount Storm Crow tokens', style: resultStyle));
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(DiceBagScreen._dieBorderRadius),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: items,
      ),
    );
  }
}

/// Card shortcut with its own X input and roll button
class _CardShortcut extends StatefulWidget {
  final String title;
  final String inputLabel;
  final void Function(int count) onRoll;

  const _CardShortcut({
    required this.title,
    required this.inputLabel,
    required this.onRoll,
  });

  @override
  State<_CardShortcut> createState() => _CardShortcutState();
}

class _CardShortcutState extends State<_CardShortcut> {
  int _count = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.inputLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _count > 1 ? () => setState(() => _count--) : null,
              icon: const Icon(Icons.remove, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            SizedBox(
              width: 28,
              child: Text(
                '$_count',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: _count < DiceBagScreen._maxDice
                  ? () => setState(() => _count++)
                  : null,
              icon: const Icon(Icons.add, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 4),
            FilledButton.tonal(
              onPressed: () => widget.onRoll(_count),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Roll'),
            ),
          ],
        ),
      ),
    );
  }
}

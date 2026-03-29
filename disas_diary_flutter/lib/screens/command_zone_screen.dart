import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/command_zone_state.dart';
import '../models/trigger_tracker.dart';
import '../providers/command_zone_state.dart';
import '../widgets/mana_icons.dart';

/// Command Zone tool screen - Life tracker with counters, status toggles,
/// per-turn trackers, and commander tracking.
class CommandZoneScreen extends StatelessWidget {
  const CommandZoneScreen({super.key});

  static const double _appBarHeight = 40;
  static const double _sectionSpacing = 16;
  static const double _contentPadding = 16;
  static const double _tileSpacing = 8;
  static const double _tileBorderRadius = 8;
  static const double _tileBorderWidth = 1;
  static const double _warningBorderWidth = 2;
  static const double _lifeTileHeight = 120;
  static const double _turnTileHeight = 80;
  static const int _lifeDeltaSmall = 1;
  static const int _lifeDeltaLarge = 10;
  static const int _turnDeltaSmall = 1;
  static const int _turnDeltaLarge = 10;
  static const int _lethalCommanderDamage = 21;
  static const double _opponentStepperButtonSize = 28;
  static const int _opponentDamageColumnsPerRow = 4;
  static const double _counterBackgroundIconOpacity = 0.12;
  static const double _statusChipBackgroundIconOpacity = 0.15;
  static const double _counterBackgroundIconSize = 32;
  static const double _statusChipBackgroundIconSize = 24;

  static const double _appBarIconSize = 20;
  static const double _refreshIconSize = 16;
  static const double _stepperIconSize = 18;
  static const double _modalButtonSize = 36;

  static const double _opponentCountWidth = 24;
  static const Duration _longPressInitialDelay = Duration(seconds: 1);
  static const Duration _longPressRepeatInterval = Duration(milliseconds: 500);
  static const double _modalPadding = 24;
  static const double _counterSquarePadding = 4;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CommandZoneState>();

    if (!state.isLoaded) {
      return Scaffold(
        appBar: _buildAppBar(context, state),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, state),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: _contentPadding,
            vertical: _contentPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Life Total
              _LifeTotalTile(lifeTotal: state.lifeTotal),
              const SizedBox(height: _sectionSpacing),
              // 2. Counters
              _CountersRow(state: state),
              const SizedBox(height: _sectionSpacing),
              // 3. Status Toggles
              _StatusTogglesRow(state: state),
              const SizedBox(height: _sectionSpacing),
              // 4. Commander Damage
              _CommanderSection(state: state),
              const SizedBox(height: _sectionSpacing),
              // 5. Trigger Tracking
              _TriggerTrackingSection(state: state),
              const SizedBox(height: _sectionSpacing),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CommandZoneState state,
  ) {
    final theme = Theme.of(context);

    return AppBar(
      toolbarHeight: _appBarHeight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: _appBarIconSize),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Command Zone',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.restart_alt, size: _appBarIconSize),
          tooltip: 'Reset all',
          onPressed: () => _showResetDialog(context, state),
        ),
      ],
    );
  }

  static const int _lifePreset20 = 20;
  static const int _lifePreset30 = 30;
  static const int _lifePreset40 = 40;

  void _showResetDialog(BuildContext context, CommandZoneState state) {
    final customController = TextEditingController();
    var selectedLife = CommandZoneGameState.defaultStartingLife;
    var isCustom = false;
    var resetTrackersToDefault = true;
    var resetCommanderConfig = true;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Reset Life Tracker'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This will reset life total, all counters, status toggles, '
                'trigger trackers, and commander data.',
              ),
              const SizedBox(height: 16),
              const Text('Reset life to:'),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final preset in [_lifePreset20, _lifePreset30, _lifePreset40]) ...[
                    Expanded(
                      child: ChoiceChip(
                        label: Text(preset.toString()),
                        selected: !isCustom && selectedLife == preset,
                        showCheckmark: false,
                        onSelected: (_) => setDialogState(() {
                          selectedLife = preset;
                          isCustom = false;
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Custom'),
                      selected: isCustom,
                      showCheckmark: false,
                      onSelected: (_) => setDialogState(() {
                        isCustom = true;
                      }),
                    ),
                  ),
                ],
              ),
              if (isCustom) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: customController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter life total',
                    isDense: true,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              CheckboxListTile(
                title: const Text('Reset trackers to default'),
                subtitle: const Text('Storm, Lands, Cards Drawn'),
                value: resetTrackersToDefault,
                onChanged: (v) => setDialogState(
                    () => resetTrackersToDefault = v ?? true),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              CheckboxListTile(
                title: const Text('Reset to commander defaults'),
                subtitle: const Text('No partner, 3 opponents'),
                value: resetCommanderConfig,
                onChanged: (v) => setDialogState(
                    () => resetCommanderConfig = v ?? true),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final life = isCustom
                    ? (int.tryParse(customController.text) ??
                        CommandZoneGameState.defaultStartingLife)
                    : selectedLife;
                context.read<CommandZoneState>().setStartingLife(life);
                context.read<CommandZoneState>().resetAll(
                  resetTrackersToDefault: resetTrackersToDefault,
                  resetCommanderConfig: resetCommanderConfig,
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Life Total — Mana Pool Style Tile
// ---------------------------------------------------------------------------

class _LifeTotalTile extends StatefulWidget {
  final int lifeTotal;

  const _LifeTotalTile({required this.lifeTotal});

  @override
  State<_LifeTotalTile> createState() => _LifeTotalTileState();
}

class _LifeTotalTileState extends State<_LifeTotalTile> {
  Timer? _repeatTimer;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  void _startLongPress(int delta) {
    final czState = context.read<CommandZoneState>();
    czState.adjustLifeTotal(delta);
    HapticFeedback.mediumImpact();
    _repeatTimer = Timer(CommandZoneScreen._longPressInitialDelay, () {
      czState.adjustLifeTotal(delta);
      HapticFeedback.mediumImpact();
      _repeatTimer = Timer.periodic(CommandZoneScreen._longPressRepeatInterval, (_) {
        czState.adjustLifeTotal(delta);
        HapticFeedback.mediumImpact();
      });
    });
  }

  void _stopLongPress() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: CommandZoneScreen._lifeTileHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: CommandZoneScreen._tileBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left/right tap zones
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) =>
                      _startLongPress(-CommandZoneScreen._lifeDeltaLarge),
                  onLongPressEnd: (_) => _stopLongPress(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context
                          .read<CommandZoneState>()
                          .adjustLifeTotal(-CommandZoneScreen._lifeDeltaSmall),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) =>
                      _startLongPress(CommandZoneScreen._lifeDeltaLarge),
                  onLongPressEnd: (_) => _stopLongPress(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context
                          .read<CommandZoneState>()
                          .adjustLifeTotal(CommandZoneScreen._lifeDeltaSmall),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Centered life total
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.lifeTotal.toString(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Counters — Single Row of Five Squares with Mana Font Background Glyphs
// ---------------------------------------------------------------------------

/// Data for a single counter type, used by both squares and shared modal.
class _CounterDef {
  final String label;
  final String fullName;
  final Widget backgroundIcon;
  final int Function(CommandZoneState) valueGetter;
  final void Function(CommandZoneState, int) onAdjust;
  final void Function(CommandZoneState) onReset;
  final bool Function(CommandZoneState) isWarning;
  final String? warningMessage;

  const _CounterDef({
    required this.label,
    required this.fullName,
    required this.backgroundIcon,
    required this.valueGetter,
    required this.onAdjust,
    required this.onReset,
    this.isWarning = _noWarning,
    this.warningMessage,
  });

  static bool _noWarning(CommandZoneState _) => false;
}

/// Builds an icon widget for counter backgrounds.
Widget _counterBackgroundIcon(IconData icon) {
  return Icon(
    icon,
    size: CommandZoneScreen._counterBackgroundIconSize,
  );
}

final List<_CounterDef> _counterDefs = [
  _CounterDef(
    label: 'Poison',
    fullName: 'Poison Counters',
    backgroundIcon: _counterBackgroundIcon(ManaIcons.toxic),
    valueGetter: (s) => s.poisonCounters,
    onAdjust: (s, d) => s.adjustPoisonCounters(d),
    onReset: (s) => s.setPoisonCounters(0),
    isWarning: (s) => s.isPoisonLethal,
    warningMessage: 'Lethal poison!',
  ),
  _CounterDef(
    label: 'Energy',
    fullName: 'Energy Counters',
    backgroundIcon: _counterBackgroundIcon(ManaIcons.energy),
    valueGetter: (s) => s.energyCounters,
    onAdjust: (s, d) => s.adjustEnergyCounters(d),
    onReset: (s) => s.setEnergyCounters(0),
  ),
  _CounterDef(
    label: 'Exp',
    fullName: 'Experience Counters',
    backgroundIcon: _counterBackgroundIcon(Icons.auto_awesome),
    valueGetter: (s) => s.experienceCounters,
    onAdjust: (s, d) => s.adjustExperienceCounters(d),
    onReset: (s) => s.setExperienceCounters(0),
  ),
  _CounterDef(
    label: 'Tickets',
    fullName: 'Tickets',
    backgroundIcon: _counterBackgroundIcon(ManaIcons.ticket),
    valueGetter: (s) => s.tickets,
    onAdjust: (s, d) => s.adjustTickets(d),
    onReset: (s) => s.setTickets(0),
  ),
  _CounterDef(
    label: 'Rad',
    fullName: 'Rad Counters',
    backgroundIcon: _counterBackgroundIcon(ManaIcons.rad),
    valueGetter: (s) => s.radCounters,
    onAdjust: (s, d) => s.adjustRadCounters(d),
    onReset: (s) => s.setRadCounters(0),
  ),
];


class _CountersRow extends StatelessWidget {
  final CommandZoneState state;

  const _CountersRow({required this.state});

  void _showSharedCounterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _SharedCounterModal(),
    );
  }

  void _showTaxModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _TaxModal(),
    );
  }

  /// Whether partner tax is active (commander 2 has tax > 0)
  bool get _hasPartnerTax =>
      state.commanderCount >= 2 && state.commanderTaxFor(1) > 0;

  @override
  Widget build(BuildContext context) {
    final tax1 = state.commanderTaxFor(0);
    final tax2 = _hasPartnerTax ? state.commanderTaxFor(1) : 0;

    return Row(
          children: [
            for (int i = 0; i < _counterDefs.length; i++) ...[
              if (i > 0) const SizedBox(width: CommandZoneScreen._tileSpacing),
              _CounterSquare(
                def: _counterDefs[i],
                value: _counterDefs[i].valueGetter(state),
                isWarning: _counterDefs[i].isWarning(state),
                onTap: () {
                  final czState = context.read<CommandZoneState>();
                  _counterDefs[i].onAdjust(czState, 1);
                },
                onLongPress: () => _showSharedCounterModal(context),
              ),
            ],
            const SizedBox(width: CommandZoneScreen._tileSpacing),
            _TaxCounterSquare(
              tax1: tax1,
              tax2: tax2,
              hasPartner: _hasPartnerTax,
              onTap: () => context
                  .read<CommandZoneState>()
                  .incrementCommanderTax(0),
              onLongPress: () => _showTaxModal(context),
            ),
          ],
        );
  }
}

class _CounterSquare extends StatelessWidget {
  final _CounterDef def;
  final int value;
  final bool isWarning;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _CounterSquare({
    required this.def,
    required this.value,
    this.isWarning = false,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warningColor = theme.colorScheme.error;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
              child: Ink(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(
                    CommandZoneScreen._tileBorderRadius,
                  ),
                  border: Border.all(
                    color: isWarning
                        ? warningColor
                        : theme.colorScheme.outline,
                    width: isWarning
                        ? CommandZoneScreen._warningBorderWidth
                        : CommandZoneScreen._tileBorderWidth,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background glyph filling the square
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: IconTheme(
                          data: IconThemeData(
                            color: (isWarning
                                    ? warningColor
                                    : theme.colorScheme.onSurfaceVariant)
                                .withValues(
                                    alpha: CommandZoneScreen
                                        ._counterBackgroundIconOpacity),
                          ),
                          child: def.backgroundIcon,
                        ),
                      ),
                    ),
                    // Value centered on top of the glyph
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value.toString(),
                        style:
                            theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isWarning
                              ? warningColor
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // Label pinned to bottom, separate layer
                    Positioned(
                      bottom: CommandZoneScreen._counterSquarePadding,
                      child: Text(
                        def.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared modal showing ALL 5 counters with full names, values, and +/- buttons.
class _SharedCounterModal extends StatelessWidget {
  const _SharedCounterModal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CommandZoneState>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(CommandZoneScreen._modalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Counters',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final def in _counterDefs) ...[
              _SharedCounterRow(def: def, state: state),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SharedCounterRow extends StatelessWidget {
  final _CounterDef def;
  final CommandZoneState state;

  const _SharedCounterRow({
    required this.def,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = def.valueGetter(state);
    final warning = def.isWarning(state);
    final czState = context.read<CommandZoneState>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    def.fullName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: warning
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (warning && def.warningMessage != null)
                    Text(
                      def.warningMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () => def.onAdjust(czState, -1),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(CommandZoneScreen._modalButtonSize, CommandZoneScreen._modalButtonSize),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('-1'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                value.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: warning
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () => def.onAdjust(czState, 1),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(CommandZoneScreen._modalButtonSize, CommandZoneScreen._modalButtonSize),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('+1'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => def.onReset(czState),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Reset'),
            ),
          ],
        ),
        Divider(color: theme.colorScheme.outlineVariant),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status Toggles — Single Row of 4 FilterChips with Faded Background Icons
// ---------------------------------------------------------------------------

class _StatusTogglesRow extends StatelessWidget {
  final CommandZoneState state;

  const _StatusTogglesRow({required this.state});

  String _dayNightLabel(bool? dayNight) {
    if (dayNight == null) return 'Day';
    return dayNight ? 'Day' : 'Night';
  }

  IconData _dayNightIcon(bool? dayNight) {
    if (dayNight == null) return Icons.brightness_medium;
    return dayNight ? Icons.wb_sunny : Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  context.read<CommandZoneState>().resetDayNight();
                },
                child: _StatusChipWithBackgroundIcon(
                  icon: _dayNightIcon(state.dayNight),
                  label: _dayNightLabel(state.dayNight),
                  selected: state.dayNight != null,
                  selectedColor: theme.colorScheme.primaryContainer,
                  onSelected: (_) =>
                      context.read<CommandZoneState>().cycleDayNight(),
                ),
              ),
            ),
            const SizedBox(width: CommandZoneScreen._tileSpacing),
            Expanded(
              child: _StatusChipWithBackgroundIcon(
                icon: Icons.auto_awesome,
                label: 'Monarch',
                selected: state.isMonarch,
                selectedColor: theme.colorScheme.primaryContainer,

                onSelected: (_) =>
                    context.read<CommandZoneState>().toggleMonarch(),
              ),
            ),
            const SizedBox(width: CommandZoneScreen._tileSpacing),
            Expanded(
              child: _StatusChipWithBackgroundIcon(
                icon: Icons.location_city,
                label: 'Ascend',
                selected: state.hasCityBlessing,
                selectedColor: theme.colorScheme.primaryContainer,

                onSelected: (_) =>
                    context.read<CommandZoneState>().toggleCityBlessing(),
              ),
            ),
            const SizedBox(width: CommandZoneScreen._tileSpacing),
            Expanded(
              child: _StatusChipWithBackgroundIcon(
                icon: Icons.flash_on,
                label: 'Initiative',
                selected: state.hasInitiative,
                selectedColor: theme.colorScheme.primaryContainer,

                onSelected: (_) =>
                    context.read<CommandZoneState>().toggleInitiative(),
              ),
            ),
          ],
        );
  }
}

/// A FilterChip with the icon rendered as a faded background behind the label
/// instead of as a leading avatar. Saves horizontal space.
class _StatusChipWithBackgroundIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color selectedColor;
  final ValueChanged<bool> onSelected;

  const _StatusChipWithBackgroundIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = (selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant)
        .withValues(alpha: CommandZoneScreen._statusChipBackgroundIconOpacity);

    return FilterChip(
      label: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              size: CommandZoneScreen._statusChipBackgroundIconSize,
              color: iconColor,
            ),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: selectedColor,
      showCheckmark: false,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(vertical: 2),
    );
  }
}

// ---------------------------------------------------------------------------
// Per-Turn Trackers — Mana Pool Style (Item 3: label below value)
// ---------------------------------------------------------------------------

class _TriggerTrackingSection extends StatelessWidget {
  final CommandZoneState state;

  const _TriggerTrackingSection({required this.state});

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _TrackerEditSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enabled = state.enabledTrackers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _SectionHeader(title: 'Trigger Trackers'),
            IconButton(
              icon: const Icon(Icons.edit, size: CommandZoneScreen._appBarIconSize),
              tooltip: 'Edit trackers',
              onPressed: () => _showEditSheet(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: CommandZoneScreen._opponentStepperButtonSize,
                minHeight: CommandZoneScreen._opponentStepperButtonSize,
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () =>
                  context.read<CommandZoneState>().resetTurnTrackers(),
              icon: const Icon(Icons.refresh, size: CommandZoneScreen._refreshIconSize),
              label: const Text('New Turn'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (enabled.isEmpty)
          const Text('No trackers enabled. Tap edit to configure.')
        else
          Wrap(
            spacing: CommandZoneScreen._tileSpacing,
            runSpacing: CommandZoneScreen._tileSpacing,
            children: [
              for (final tracker in enabled)
                SizedBox(
                  width: _trackerTileWidth(context, enabled.length),
                  child: _TurnTrackerTile(
                    label: tracker.label,
                    value: tracker.value,
                    onAdjustSmall: (delta) => context
                        .read<CommandZoneState>()
                        .adjustTrackerValue(tracker.id, delta),
                    onAdjustLarge: (delta) => context
                        .read<CommandZoneState>()
                        .adjustTrackerValue(tracker.id, delta),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  /// Calculate tile width so tiles fill the row evenly.
  /// For 1-4 trackers, fit them in one row. For 5+, use rows of 4.
  double _trackerTileWidth(BuildContext context, int count) {
    final screenWidth = MediaQuery.of(context).size.width;
    final available = screenWidth - (CommandZoneScreen._contentPadding * 2);
    final perRow = count <= CommandZoneScreen._opponentDamageColumnsPerRow
        ? count
        : CommandZoneScreen._opponentDamageColumnsPerRow;
    final gaps = (perRow - 1) * CommandZoneScreen._tileSpacing;
    return (available - gaps) / perRow;
  }
}

class _TurnTrackerTile extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onAdjustSmall;
  final ValueChanged<int> onAdjustLarge;

  const _TurnTrackerTile({
    required this.label,
    required this.value,
    required this.onAdjustSmall,
    required this.onAdjustLarge,
  });

  @override
  State<_TurnTrackerTile> createState() => _TurnTrackerTileState();
}

class _TurnTrackerTileState extends State<_TurnTrackerTile> {
  Timer? _repeatTimer;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  void _startLongPress(int largeDelta) {
    widget.onAdjustLarge(largeDelta);
    HapticFeedback.mediumImpact();
    _repeatTimer = Timer(CommandZoneScreen._longPressInitialDelay, () {
      widget.onAdjustLarge(largeDelta);
      HapticFeedback.mediumImpact();
      _repeatTimer = Timer.periodic(CommandZoneScreen._longPressRepeatInterval, (_) {
        widget.onAdjustLarge(largeDelta);
        HapticFeedback.mediumImpact();
      });
    });
  }

  void _stopLongPress() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: CommandZoneScreen._turnTileHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
        border: Border.all(
          color: theme.colorScheme.outline,
          width: CommandZoneScreen._tileBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) =>
                      _startLongPress(-CommandZoneScreen._turnDeltaLarge),
                  onLongPressEnd: (_) => _stopLongPress(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.value > 0
                          ? () => widget
                              .onAdjustSmall(-CommandZoneScreen._turnDeltaSmall)
                          : null,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) =>
                      _startLongPress(CommandZoneScreen._turnDeltaLarge),
                  onLongPressEnd: (_) => _stopLongPress(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () =>
                          widget.onAdjustSmall(CommandZoneScreen._turnDeltaSmall),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Item 3: value on top, label below
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.all(CommandZoneScreen._counterSquarePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.value.toString(),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tracker Edit Sheet — Manage custom & default trackers
// ---------------------------------------------------------------------------

class _TrackerEditSheet extends StatefulWidget {
  const _TrackerEditSheet();

  @override
  State<_TrackerEditSheet> createState() => _TrackerEditSheetState();
}

class _TrackerEditSheetState extends State<_TrackerEditSheet> {
  final _labelController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _addTracker() {
    final label = _labelController.text.trim();
    if (label.isEmpty) return;
    context.read<CommandZoneState>().addCustomTracker(label);
    _labelController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CommandZoneState>();
    final trackers = state.triggerTrackers;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: CommandZoneScreen._modalPadding,
          right: CommandZoneScreen._modalPadding,
          top: CommandZoneScreen._modalPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom + CommandZoneScreen._modalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Trackers',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final tracker in trackers)
              _TrackerEditRow(tracker: tracker),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _labelController,
                    decoration: const InputDecoration(
                      hintText: 'New tracker name',
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addTracker(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: CommandZoneScreen._modalButtonSize),
                  onPressed: _addTracker,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackerEditRow extends StatelessWidget {
  final TriggerTracker tracker;

  const _TrackerEditRow({required this.tracker});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.read<CommandZoneState>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tracker.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tracker.isEnabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (tracker.isDefault)
            Icon(
              Icons.lock_outline,
              size: CommandZoneScreen._stepperIconSize,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          Switch(
            value: tracker.isEnabled,
            onChanged: (_) => state.toggleTrackerEnabled(tracker.id),
          ),
          if (!tracker.isDefault)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: CommandZoneScreen._appBarIconSize,
                color: theme.colorScheme.error,
              ),
              onPressed: () => state.deleteTracker(tracker.id),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: CommandZoneScreen._opponentStepperButtonSize,
                minHeight: CommandZoneScreen._opponentStepperButtonSize,
              ),
            )
          else
            const SizedBox(width: CommandZoneScreen._opponentStepperButtonSize),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Commander Section — Compact Layout
// ---------------------------------------------------------------------------

class _CommanderSection extends StatelessWidget {
  final CommandZoneState state;

  const _CommanderSection({required this.state});

  int _totalDamageForOpponent(int opponentIndex) {
    int total = 0;
    for (int cmd = 0; cmd < state.commanderCount; cmd++) {
      total += state.commanderDamageFor(
        commanderIndex: cmd,
        opponentIndex: opponentIndex,
      );
    }
    return total;
  }

  /// Per rule 702.124d / 903.10a, lethality is per-commander, not combined.
  bool _isLethalForOpponent(int opponentIndex) {
    for (int cmd = 0; cmd < state.commanderCount; cmd++) {
      if (state.commanderDamageFor(
            commanderIndex: cmd,
            opponentIndex: opponentIndex,
          ) >=
          CommandZoneScreen._lethalCommanderDamage) {
        return true;
      }
    }
    return false;
  }

  void _showConfigSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _CommanderConfigSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _SectionHeader(title: 'Commander Damage'),
            IconButton(
              icon: const Icon(Icons.edit, size: CommandZoneScreen._appBarIconSize),
              tooltip: 'Commander config',
              onPressed: () => _showConfigSheet(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: CommandZoneScreen._opponentStepperButtonSize,
                minHeight: CommandZoneScreen._opponentStepperButtonSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Opponent damage squares
        _OpponentDamageGrid(
          opponentCount: state.opponentCount,
          commanderCount: state.commanderCount,
          state: state,
          totalDamageForOpponent: _totalDamageForOpponent,
          isLethalForOpponent: _isLethalForOpponent,
        ),
      ],
    );
  }
}

/// Bottom sheet for configuring opponent count and commander count
class _CommanderConfigSheet extends StatelessWidget {
  const _CommanderConfigSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CommandZoneState>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(CommandZoneScreen._modalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Commander Config',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Opponent count stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Opponents:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove, size: CommandZoneScreen._stepperIconSize),
                  onPressed: state.opponentCount >
                          CommandZoneGameState.minOpponents
                      ? () => context
                          .read<CommandZoneState>()
                          .setOpponentCount(state.opponentCount - 1)
                      : null,
                ),
                SizedBox(
                  width: CommandZoneScreen._opponentCountWidth,
                  child: Text(
                    state.opponentCount.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: CommandZoneScreen._stepperIconSize),
                  onPressed: state.opponentCount <
                          CommandZoneGameState.maxOpponents
                      ? () => context
                          .read<CommandZoneState>()
                          .setOpponentCount(state.opponentCount + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tax counter square — sits in the counters row. Shows split display
/// when partner tax is active (commander 2 has tax > 0).
class _TaxCounterSquare extends StatelessWidget {
  final int tax1;
  final int tax2;
  final bool hasPartner;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _TaxCounterSquare({
    required this.tax1,
    required this.tax2,
    required this.hasPartner,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
              child: Ink(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: CommandZoneScreen._tileBorderWidth,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background icon
                    Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: IconTheme(
                          data: IconThemeData(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: CommandZoneScreen._counterBackgroundIconOpacity),
                          ),
                          child: const Icon(Icons.balance),
                        ),
                      ),
                    ),
                    // Value display
                    Padding(
                      padding: const EdgeInsets.all(CommandZoneScreen._counterSquarePadding),
                      child: hasPartner
                          ? Row(
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      tax1.toString(),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '|',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      tax2.toString(),
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                tax1.toString(),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                    ),
                    // Label pinned to bottom, separate layer
                    Positioned(
                      bottom: CommandZoneScreen._counterSquarePadding,
                      child: Text(
                        'Tax',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tax modal — manage tax for commander and optionally partner.
/// If partner tax has never been set, shows a button to enable it.
class _TaxModal extends StatelessWidget {
  const _TaxModal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CommandZoneState>();
    final tax1 = state.commanderTaxFor(0);
    final hasPartner = state.commanderCount >= 2 && state.commanderTaxFor(1) > 0;
    final tax2 = state.commanderTaxFor(1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(CommandZoneScreen._modalPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Commander Tax',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _TaxModalSection(
                label: hasPartner ? 'Commander 1' : 'Commander',
                value: tax1,
                commanderIndex: 0,
              ),
              if (hasPartner) ...[
                const SizedBox(height: 16),
                _TaxModalSection(
                  label: 'Commander 2 (Partner)',
                  value: tax2,
                  commanderIndex: 1,
                ),
              ],
              const SizedBox(height: 16),
              if (!hasPartner && state.commanderCount < 2)
                FilledButton.tonal(
                  onPressed: () {
                    // Enable partner: set commander count to 2 and give partner 0 tax
                    context.read<CommandZoneState>().setCommanderCount(2);
                    context.read<CommandZoneState>().incrementCommanderTax(1);
                  },
                  child: const Text('Add Partner Tax'),
                )
              else if (!hasPartner && state.commanderCount >= 2)
                FilledButton.tonal(
                  onPressed: () =>
                      context.read<CommandZoneState>().incrementCommanderTax(1),
                  child: const Text('Add Partner Tax'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaxModalSection extends StatelessWidget {
  final String label;
  final int value;
  final int commanderIndex;

  const _TaxModalSection({
    required this.label,
    required this.value,
    required this.commanderIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
              onPressed: value > 0
                  ? () => context
                      .read<CommandZoneState>()
                      .decrementCommanderTax(commanderIndex)
                  : null,
              child: const Text('-2'),
            ),
            const SizedBox(width: 16),
            FilledButton.tonal(
              onPressed: () => context
                  .read<CommandZoneState>()
                  .incrementCommanderTax(commanderIndex),
              child: const Text('+2'),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => context
                  .read<CommandZoneState>()
                  .resetCommanderTax(commanderIndex),
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Builds opponent damage squares using Expanded children in Rows.
/// Item 4: max 4 per row, flex to fill width.
class _OpponentDamageGrid extends StatelessWidget {
  final int opponentCount;
  final int commanderCount;
  final CommandZoneState state;
  final int Function(int) totalDamageForOpponent;
  final bool Function(int) isLethalForOpponent;

  const _OpponentDamageGrid({
    required this.opponentCount,
    required this.commanderCount,
    required this.state,
    required this.totalDamageForOpponent,
    required this.isLethalForOpponent,
  });

  /// Split opponents into balanced rows.
  /// 1-4: single row. 5: 3+2. 6: 3+3. 7: 4+3. 8: 4+4.
  List<List<int>> _balancedRows() {
    final opponents = List.generate(opponentCount, (i) => i);
    if (opponentCount <= CommandZoneScreen._opponentDamageColumnsPerRow) {
      return [opponents];
    }
    final topCount = (opponentCount + 1) ~/ 2; // ceil division
    return [
      opponents.sublist(0, topCount),
      opponents.sublist(topCount),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rows = _balancedRows();
    // Max height = what a tile would be at 4-per-row (square at that width)
    final screenWidth = MediaQuery.of(context).size.width;
    final available = screenWidth - (CommandZoneScreen._contentPadding * 2);
    const gaps = (CommandZoneScreen._opponentDamageColumnsPerRow - 1) *
        CommandZoneScreen._tileSpacing;
    final maxTileHeight = (available - gaps) /
        CommandZoneScreen._opponentDamageColumnsPerRow;

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0)
            const SizedBox(height: CommandZoneScreen._tileSpacing),
          Row(
            children: [
              for (int c = 0; c < rows[r].length; c++) ...[
                if (c > 0)
                  const SizedBox(width: CommandZoneScreen._tileSpacing),
                Expanded(
                  child: _OpponentDamageSquare(
                    opponentIndex: rows[r][c],
                    totalDamage: totalDamageForOpponent(rows[r][c]),
                    isLethal: isLethalForOpponent(rows[r][c]),
                    commanderCount: commanderCount,
                    state: state,
                    maxHeight: maxTileHeight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _OpponentDamageSquare extends StatelessWidget {
  final int opponentIndex;
  final int totalDamage;
  final bool isLethal;
  final int commanderCount;
  final CommandZoneState state;
  final double maxHeight;


  const _OpponentDamageSquare({
    required this.opponentIndex,
    required this.totalDamage,
    required this.isLethal,
    required this.commanderCount,
    required this.state,
    required this.maxHeight,
  });

  bool get _hasPartnerDamage {
    if (commanderCount < 2) return false;
    final cmd1 = state.commanderDamageFor(
        commanderIndex: 0, opponentIndex: opponentIndex);
    final cmd2 = state.commanderDamageFor(
        commanderIndex: 1, opponentIndex: opponentIndex);
    return cmd1 > 0 || cmd2 > 0;
  }

  void _showDamageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _OpponentDamageModal(
        opponentIndex: opponentIndex,
        commanderCount: commanderCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warningColor = theme.colorScheme.error;
    final showPartner = _hasPartnerDamage;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: GestureDetector(
        onLongPress: () => _showDamageModal(context),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Tap: +1 damage to commander index 0 by default
              context.read<CommandZoneState>().adjustCommanderDamage(
                    commanderIndex: 0,
                    opponentIndex: opponentIndex,
                    delta: 1,
                  );
            },
            borderRadius:
                BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
            child: Ink(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius:
                    BorderRadius.circular(CommandZoneScreen._tileBorderRadius),
                border: Border.all(
                  color: isLethal ? warningColor : theme.colorScheme.outline,
                  width: isLethal
                      ? CommandZoneScreen._warningBorderWidth
                      : CommandZoneScreen._tileBorderWidth,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(CommandZoneScreen._counterSquarePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: showPartner
                          ? _buildPartnerDisplay(theme, warningColor)
                          : _buildSingleDisplay(theme, warningColor),
                    ),
                    Text(
                      'Opp ${opponentIndex + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isLethal
                            ? warningColor
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSingleDisplay(ThemeData theme, Color warningColor) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        totalDamage.toString(),
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLethal ? warningColor : theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildPartnerDisplay(ThemeData theme, Color warningColor) {
    final dmg1 = state.commanderDamageFor(
        commanderIndex: 0, opponentIndex: opponentIndex);
    final dmg2 = state.commanderDamageFor(
        commanderIndex: 1, opponentIndex: opponentIndex);
    final valueColor = isLethal ? warningColor : theme.colorScheme.onSurface;
    final dividerColor = isLethal
        ? warningColor
        : theme.colorScheme.onSurfaceVariant;
    final valueStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: valueColor,
    );

    return Row(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(dmg1.toString(), style: valueStyle),
          ),
        ),
        Text(
          '|',
          style: theme.textTheme.titleSmall?.copyWith(
            color: dividerColor,
            fontWeight: FontWeight.w300,
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(dmg2.toString(), style: valueStyle),
          ),
        ),
      ],
    );
  }
}

class _OpponentDamageModal extends StatelessWidget {
  final int opponentIndex;
  final int commanderCount;

  const _OpponentDamageModal({
    required this.opponentIndex,
    required this.commanderCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<CommandZoneState>();

    // Per 702.124d / 903.10a: lethality is per-commander
    int total = 0;
    bool isLethal = false;
    for (int cmd = 0; cmd < commanderCount; cmd++) {
      final dmg = state.commanderDamageFor(
        commanderIndex: cmd,
        opponentIndex: opponentIndex,
      );
      total += dmg;
      if (dmg >= CommandZoneScreen._lethalCommanderDamage) {
        isLethal = true;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(CommandZoneScreen._modalPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Opponent ${opponentIndex + 1} - Commander Damage',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isLethal) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(
                    CommandZoneScreen._tileBorderRadius,
                  ),
                ),
                child: Text(
                  'Lethal commander damage!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (commanderCount > 1) ...[
              const SizedBox(height: 8),
              Text(
                'Total: $total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isLethal
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
            const SizedBox(height: 16),
            for (int cmd = 0; cmd < commanderCount; cmd++)
              _CommanderDamageModalSection(
                commanderIndex: cmd,
                opponentIndex: opponentIndex,
                commanderCount: commanderCount,
                damage: state.commanderDamageFor(
                  commanderIndex: cmd,
                  opponentIndex: opponentIndex,
                ),
              ),
          ],
          ),
        ),
      ),
    );
  }
}

class _CommanderDamageModalSection extends StatelessWidget {
  final int commanderIndex;
  final int opponentIndex;
  final int commanderCount;
  final int damage;

  const _CommanderDamageModalSection({
    required this.commanderIndex,
    required this.opponentIndex,
    required this.commanderCount,
    required this.damage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = commanderCount > 1 ? 'Commander ${commanderIndex + 1}' : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            damage.toString(),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () => context
                    .read<CommandZoneState>()
                    .adjustCommanderDamage(
                      commanderIndex: commanderIndex,
                      opponentIndex: opponentIndex,
                      delta: -5,
                    ),
                child: const Text('-5'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () => context
                    .read<CommandZoneState>()
                    .adjustCommanderDamage(
                      commanderIndex: commanderIndex,
                      opponentIndex: opponentIndex,
                      delta: -1,
                    ),
                child: const Text('-1'),
              ),
              const SizedBox(width: 16),
              FilledButton.tonal(
                onPressed: () => context
                    .read<CommandZoneState>()
                    .adjustCommanderDamage(
                      commanderIndex: commanderIndex,
                      opponentIndex: opponentIndex,
                      delta: 1,
                    ),
                child: const Text('+1'),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: () => context
                    .read<CommandZoneState>()
                    .adjustCommanderDamage(
                      commanderIndex: commanderIndex,
                      opponentIndex: opponentIndex,
                      delta: 5,
                    ),
                child: const Text('+5'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => context
                .read<CommandZoneState>()
                .setCommanderDamage(
                  commanderIndex: commanderIndex,
                  opponentIndex: opponentIndex,
                  damage: 0,
                ),
            child: const Text('Reset to 0'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared Widgets
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
